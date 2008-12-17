Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760192AbYLQIHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbYLQIHa (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 03:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYLQIHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 03:07:18 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYLQIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 03:07:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=I/mnaQ0LexOv4LHEptYA07EsdO0pMgMuiIJ4ZPobrtLysIiEyz5ojawFji3xXtRMX
	f13nsrESDRdUg4hINC5Jg==
MIME-Version: 1.0
In-Reply-To: <20081216101551.GA27481@elte.hu>
References: <b040c32a0812160032pf681f13s9e5e86c4b5448012@mail.gmail.com>
	 <20081216091509.GA29872@elte.hu> <49477452.6030307@goop.org>
	 <20081216101551.GA27481@elte.hu>
Date: Wed, 17 Dec 2008 00:07:12 -0800
Message-ID: <b040c32a0812170007s59600707h5a8597a1cbe9cc21@mail.gmail.com>
Subject: Re: [patch] x86: convert rdtscll() to use __native_read_tsc
From: Ken Chen <kenchen@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 2:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
> agreed mostly, with this twist: vdso inlining dependencies should be
> expressed explicitly, via:
>
>  native_vread_tsc()
>
> but we can also make native_read_tsc() __always_inline [it's a single
> instruction with basically no preparatory halo around that instruction]
> and document the vdso detail there.

Given that vdso already uses the inline version of __native_read_tsc,
we don't really have churn all that code around.  I also take your
analysis as there is no issue in converting rdtscll() to
__native_read_tsc().  Would it be possible for you to merge the patch
then?

- Ken
