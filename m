Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbZEUWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbZEUWn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbZEUWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:43:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZEUWnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:43:20 -0400
Date: Thu, 21 May 2009 18:42:33 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
Message-ID: <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <4A0B62F7.5030802@goop.org>
References: <4A0B62F7.5030802@goop.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 17:16:55 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Paravirt patching turns all the pvops calls into direct calls, so
> _spin_lock etc do end up having direct calls.  For example, the compiler
> generated code for paravirtualized _spin_lock is:
> 
> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
> <_spin_lock+15>:	callq  *0xffffffff805a5b30
> <_spin_lock+22>:	retq
> 
> The indirect call will get patched to:
> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
> <_spin_lock+15>:	callq <__ticket_spin_lock>
> <_spin_lock+20>:	nop; nop		/* or whatever 2-byte nop */
> <_spin_lock+22>:	retq
> 

Can't those calls be changed to jumps?
