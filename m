Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbZAMXSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbZAMXSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZAMXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:17:31 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:42349 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbZAMXR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:17:29 -0500
Message-ID: <496D20FB.5010307@knaff.lu>
Date: Wed, 14 Jan 2009 00:17:15 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: The policy on initramfs decompression failure
References: <496D17F9.8080605@zytor.com>
In-Reply-To: <496D17F9.8080605@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> As part of the multi-compression-formats patch, the issue has come up as 
> to what is the preferred policy is on initramfs decompression failure, 
> due to either corruption or due to the use of a compression format which 
> the kernel does not support.
> 
> I had personally assumed the proper policy would be to panic, since it 
> is unlikely to mean the system can be booted.  However, Ingo brought up 
> the case where the initramfs is auxilliary to being able to boot the 
> full system, for example the initramfs supplied is primarily a data 
> carrier, and either the builtin initramfs or the kernel itself is 
> sufficient to boot.
> 
> By this argument, we should change initramfs decoding failure to a 
> KERN_CRIT message, and in the (presumably most common) case that it does 
> not suffice to boot the system, we will get a panic in short order as 
> the system is unable to find init.
> 
> This argument seems to mostly hold water, but it does implement a policy 
> change over the current code.  Furthermore, it does make me concerned 
> that a *partial* decoding failure (such as can be caused by a corrupt 
> image, or, say, a gzipped image concatenated to a bzip2 image, with the 
> kernel only supporting bzip2) could cause a booted-but-dysfunctional 
> system, which is in many configurations a worse failure mode than a panic.
> 
> Hence I would like to solicit opinions about what the policy should be.
> 
> 	-hpa

There is also the additional issue that continuing to boot might hide
the original error message. Indeed, the kernel might panic eventually
(as you said, for example due to missing init), but in the meantime the
original "junk in compressed archive" might have scrolled off the
screen. And after a panic, shift+pageup does not work to inspect past
messages.

Regards,

Alain

