Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbZAMWm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbZAMWm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZAMWmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:42:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54227 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZAMWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:42:07 -0500
Message-ID: <496D17F9.8080605@zytor.com>
Date: Tue, 13 Jan 2009 14:38:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ftp.linux.org.uk>, Alain Knaff <alain@knaff.lu>
Subject: The policy on initramfs decompression failure
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the multi-compression-formats patch, the issue has come up as 
to what is the preferred policy is on initramfs decompression failure, 
due to either corruption or due to the use of a compression format which 
the kernel does not support.

I had personally assumed the proper policy would be to panic, since it 
is unlikely to mean the system can be booted.  However, Ingo brought up 
the case where the initramfs is auxilliary to being able to boot the 
full system, for example the initramfs supplied is primarily a data 
carrier, and either the builtin initramfs or the kernel itself is 
sufficient to boot.

By this argument, we should change initramfs decoding failure to a 
KERN_CRIT message, and in the (presumably most common) case that it does 
not suffice to boot the system, we will get a panic in short order as 
the system is unable to find init.

This argument seems to mostly hold water, but it does implement a policy 
change over the current code.  Furthermore, it does make me concerned 
that a *partial* decoding failure (such as can be caused by a corrupt 
image, or, say, a gzipped image concatenated to a bzip2 image, with the 
kernel only supporting bzip2) could cause a booted-but-dysfunctional 
system, which is in many configurations a worse failure mode than a panic.

Hence I would like to solicit opinions about what the policy should be.

	-hpa
