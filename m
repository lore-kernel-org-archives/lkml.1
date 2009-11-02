Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZKBQqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZKBQqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZKBQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:46:20 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:19879 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZKBQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aWOPb59gPh8HkI9p5XtLumhdY1pmeyR4p0xPc8fj9gelyLH7u62zaC/8gZWF2MO1hQ
         GDidOKenB0PEmnrTrcOJPjxSzhSp4by1JpddHHIe+74uxRKmNHTrXQWqVbv58M06iHq6
         T+PKvND22BVlRK0b/Ph+MZkTIOn/1SEwLu9LM=
Date: Mon, 2 Nov 2009 17:46:21 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: dimm <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [ RFC, PATCH - 1/2 ] x86-microcode: refactor microcode output
 messages
Message-ID: <20091102164621.GF30802@alberich.amd.com>
References: <1257114179.6833.47.camel@dimm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257114179.6833.47.camel@dimm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 11:22:59PM +0100, dimm wrote:
> 
> Hi,
> 
> 
> this is in response to Mike's patch "Limit the number of microcode
> messages".
> 
> What's about the following (yet preliminary and not thoroughly tested)
> approach?

Hmm, patch-1 doesn't apply:

 patching file arch/x86/include/asm/microcode.h
 patching file arch/x86/kernel/microcode_amd.c
 Hunk #1 succeeded at 152 (offset -4 lines).
 Hunk #2 succeeded at 240 (offset -7 lines).
 patch: **** malformed patch at line 99: size_t size)


> patch-1:
> 
> simplify 'struct ucode_cpu_info' and related operational logic.
> 
> 
> patch-2: 
> 
> reduce a number of similar 'microcode version' messages by printing a
> single message for all cpus with equal microcode version, like:

Would be useful on systems with many cores.

On AMD multi-socket systems often you have the same CPU revisions and
thus you'd like to have similar ucode on all cores. Hence there is a
high chance that your code would reduce the amount of microcode log
messages during boot.

I'd like to test it but would need patches that do apply ...


Thanks,
Andreas
