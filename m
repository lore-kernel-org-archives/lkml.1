Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbXFVXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbXFVXBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXFVXAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:00:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:60535 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXFVXAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:00:52 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
To: Rene Herman <rene.herman@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Bart Trojanowski <bart@jukie.net>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Sat, 23 Jun 2007 01:00:17 +0200
References: <8bFEz-3B4-39@gated-at.bofh.it> <8c6EE-4Jj-5@gated-at.bofh.it> <8yGrK-4vX-7@gated-at.bofh.it> <8yRnb-4XE-23@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I1s6z-0000yc-MF@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/4haRKT1IJQRhgmgcywggANzFl+oimeFnEc3W
 Yh43rNBJBZKlGkEFtj20bAVQQizoYzmxcyuWvzSANJHPUtGG6S
 yqpLApVlK8rTtfF5cuI2A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> wrote:

> The point was that real mode could only access the first 1M, not
> the first 16... :-)

The real mode on i386+ can actually access the whole 4GB address range due to
a former-bug-now-feature in the i386+. This "bug" causes the segment limit
to not be reset on return to real mode, but only on subsequent assigns to
the segment registers/selectors. Using a rarely used segment register like
GS, you could use extended memory in your program.

Obviously this needs 1) Entering and returning from protected mode, 2) all
programs to agree not to clobber GS and 3) not using v86 mode (EMM386.exe).
Therefore and because it was discovered in the late days of DOS it was not
in widespread use. Some DOS extenders were reported to use it ...

http://www.programmersheaven.com/mb/x86_asm/344953/344953/readmessage.aspx
-- 
The programmer's National Anthem is 'AAAAAAAAHHHHHHHH' 

Friﬂ, Spammer: vO9EZegbA@hBtpA.7eggert.dyndns.org
 maFsnwE@Fvznj.7eggert.dyndns.org mhF-@PoxRjk.7eggert.dyndns.org
