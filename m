Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYDWSdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYDWSdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYDWSdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:33:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59922 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYDWSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=nd7gmYoooT6++mbMTM79jbQoHRxYSjToG+Ck3V0kxGsnC5QB5QfIvhdAhxsdqIZxw4r2yh5odsmWhJneVNYbjOCDtr8w1JIt5//NuoPfYcW/lXtT25TggXA4jBrpJv/gDUyuvD+V0++S4mNt+jkMEL6ZbNhYLvrRCS/9qPOc6CI=
Date: Wed, 23 Apr 2008 22:26:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Message-ID: <20080423182615.GA7713@cvg>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <1208917076.9212.721.camel@pmac.infradead.org> <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com> <480F7C11.8040302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480F7C11.8040302@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Apr 23, 2008 at 11:12:33AM -0700]
> Cyrill Gorcunov wrote:
>> Hi David,
>> actually, this CONFIG_VM86 was there even before the renaming was done.
>> The main questions (imo) - is there any user space application who uses
>> these flags? If they are - then even the idea of this patch was a bit 
>> bogus,
>> and I should *not* remove all these VM86 specific flags but better define 
>> them
>> as aliases on flags from processor-flags.h.
>
> Hard to know.  VM86 is only used by a handful of applications (DOSEMU, 
> X.org, others?) but it's hard to know what exactly they are.
>
> The fact that noone hollered when that CONFIG_VM86 went in is probably a 
> good hint that they don't matter, but it's hard to say for sure.
>
> 	-hpa
>

Actually, being google a bit I found that most of emulators
redefine their own equvalence of these flags. So I think
we could remain all as is. But if we wanna be sure I could
make a patch like this

...
#define CF_MASK X86_EFLAGS_CF
...

		- Cyrill -

