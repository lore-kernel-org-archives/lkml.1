Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXBVHkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXBVHkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 02:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932730AbXBVHkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 02:40:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:14012 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbXBVHko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 02:40:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=agfMN20Dadtiy6uWOU4lMFUSGgPFyPxz3BxVE4GdMfb/F424IfKwTzhRtfZDzOeUy2tIKrTt7Z/K28/LID5YfZk3LLQEdNt5gGVF9rHqgY4r2900vQmFZqQXg0QHqfSq3h4RPb1/XeznpQ+x2qT40PxYcBb7m2sYTMCKP8u/riM=
Date: Thu, 22 Feb 2007 07:39:30 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jose Goncalves <jose.goncalves@inov.pt>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070222073930.GB4113@slug>
References: <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt> <20070221230503.GA28156@flint.arm.linux.org.uk> <45DD30DE.20503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DD30DE.20503@zytor.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 09:57:50PM -0800, H. Peter Anvin wrote:
> Russell King wrote:
> 
> >Plainly, %ebx changed across the call to serial_in() at c01c0f7b.
> >First thing to notice is this violates the C code - "up" can not
> >change.
> >Now let's look at serial_in:
> >c01bfa70:       55                      push   %ebp
> >c01bfa71:       89 e5                   mov    %esp,%ebp
> >c01bfa73:       53                      push   %ebx
> >...
> >c01bfab7:       5b                      pop    %ebx
> >c01bfab8:       5d                      pop    %ebp
> >c01bfab9:       c3                      ret
> >This code tells the CPU to preserves %ebx and %ebp.  But we know %ebx
> >_wasn't_ preserved.  Ergo, your CPU is plainly not doing what the code
> >told it to do.
> 
> ... assuming nothing else clobbered the stack slot (which would be a compiler 
> error, or a wild pointer.)
> 
> Got a disassembly of the whole function?
> 
Jose posted it higher in the thread:
http://lkml.org/lkml/2007/2/21/139

Regards,
Frederik
