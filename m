Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbXLQM7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbXLQM7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXLQM7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:59:36 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52305 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbXLQM7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:59:35 -0500
To: indan@nul.nu
Cc: david@davidnewall.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <476512F1.5010701@davidnewall.com>
	<200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
	<46595.81.207.0.53.1197823928.squirrel@secure.samage.net>
	<200712170040.lBH0e6sf099887@www262.sakura.ne.jp>
	<54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
In-Reply-To: <54137.81.207.0.53.1197891890.squirrel@secure.samage.net>
Message-Id: <200712172159.HGE65679.LQJOOFFFVMOHSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 17 Dec 2007 21:59:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Indan Zupancic wrote:
> If MAC can avoid all that, then why can't it also avoid tampering with /dev?

If MAC implementation handles filename and its attributes pair, this filesystem is not needed.
But I don't know MAC implementations that handle this pair.

SELinux's granularity is "allow foo_t to create block device file in dev_t directory".
TOMOYO's granularity is "allow foo to create block device file named /dev/sda1".
Both don't enforce filename and its attributes pair,
thus the attacker with root privilege can create fake device files
if he/she is permitted to create device files by MAC's policy.

It would be possible to handle this pair within MAC's policy
by expanding their policy syntaxes,
but offloading this handling on filesystem can make MAC's policy syntax simple
because filename and its attributes pairs are conventionally constant.
You won't let foo_t to create /dev/sda1 with block-8-1 attributes
and let bar_t to create /dev/sda1 with block-8-2 attributes, will you?
You don't want to describe attribute information to every entry in MAC's policy, do you?
It is redundant to describe this attribute enforcement information in MAC's policy
unless you want to break conventional filename and its attributes pairs.

> What security does your filesystem add at all, if it's useless without a MAC
> doing all the hard work?
Allow / partition to be mounted for read-only mode.
Allow /dev partition to be enforced filename and its attributes
to avoid /dev/null spoofing (create /dev/null as a regular file for eavesdropping purpose).

This filesystem adds filename and its attributes enforcement,
but it is overridable if this filesystem is used without MAC.
This filesystem adds unoverridable filename and its attributes enforcement
if this filesystem is used with MAC.

Regards.
