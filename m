Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZA1XFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZA1XFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZA1XE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:04:57 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:48734 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbZA1XE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:04:56 -0500
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to
	reduce caller register pressure
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4980A07D.3010008@goop.org>
References: <4980A07D.3010008@goop.org>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 15:05:03 -0800
Message-Id: <1233183903.16317.242.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 10:14 -0800, Jeremy Fitzhardinge wrote:
> Hi Guys,

> Zach: I wasn't really sure of what the VMI ABI calling convention is, so
> I haven't converted VMI yet.  I wasn't sure if it needs a register
> saving thunk to wrap the calls, or if they're guaranteed to not trash
> anything other than eax/rax.  Please advise.

C-like, allowing C or assembly implementations of calls.  Currently
several of the most important calls have a restricted clobber set,
however, and since it's clear there aren't any forthcoming new
implementations of a VMI ROM, it might be better to go with the actual
clobbers for performance critical ops.

> Standard calling convention is:
>          arguments          return      scratch
> x86-32   eax edx ecx        eax         ?

ecx, edx

> The most common paravirt ops, both statically and dynamically, are
> interrupt enable/disable/save/restore, so handle them first.  This is
> particularly easy since their calls are handled specially anyway.

> XXX Deal with VMI.  What's their calling convention?

Enable/Disable have no clobbers at all.
Save clobbers only return value, %eax
Restore also clobbers nothing.

The patching code has gotten quite complex with the 32/64 union; let me
apply it first and see before I comment on the patch.

Zach

