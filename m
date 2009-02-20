Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbZBTAhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbZBTAhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZBTAhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:37:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:22015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZBTAhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BEp/AjlpMb6Mazf4Jn/xWoAc1h6QUTkFpSLn9rJWvzG3EU6mp4FlIaN6kd2ebWsCXR
         A/YI3wZu0q21qIjT+W1uFdAYUlL6qYk7DsGMhN3o2hW21sWnd+y7shdZkJdJZq2mmLhy
         R9IGORFqtEVRl/QbsB1rvy8k9TMKmo9yeqVQI=
MIME-Version: 1.0
In-Reply-To: <1234952753.10531.48.camel@andreas-laptop>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
Date: Fri, 20 Feb 2009 01:37:05 +0100
Message-ID: <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Andreas Robinson <andr345@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've run some tests now and the results are not quite what I expected.

There are 3 cases:

Case 1 used a monolithic kernel with a full set of 95 inked-in
external modules.
Case 2 loaded a single mega-module (same set of 95 modules of course)
while case 3 looped through a list of pathnames and called insmod on
each one.

The test machine boots the monolithic kernel in 6.27 seconds. This is
about 0.5 seconds faster than the other two cases, that were roughly
equal.

The setup:

HP pavillion dv6300 laptop,
TL-56 Turion 64 X2 CPU @1.8GHz, 5400 RPM 2.5" Seagate SATA drive

Linux 2.6.29-rc5, with the .config derived from the generic Ubuntu 8.10 kernel.

All three cases had a minimal initramfs with busybox, insmod and an
init script that only inserted modules and then halted. IOW, no root
fs was mounted.

The results:

1. Monolithic:  6.27 s, (0.22). bzImg=3419 kB ramfs=515 kB
2. Megamodule:  6.80 s, (0.16). bzImg=2297 kB ramfs=1783 kB
3. Insmod list: 6.83 s, (0.07). bzImg=2297 kB ramfs=1942 kB

10 samples were taken in each case. Standard deviations are in parenthesis.
The measured times are printk timestamps from a dummy module inserted last.

Reading these benchmark results I can only conclude that my work is
useless and life has no meaning.

So, what's missing or been done wrong here? I expected the difference
between monolithic and modular to be greater to be honest.

Cheers,
Andreas
