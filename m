Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYHPCi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYHPCi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYHPCiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:38:17 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54408 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbYHPCiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:38:17 -0400
Message-ID: <48A63D98.3070900@lwfinger.net>
Date: Fri, 15 Aug 2008 21:38:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Regression in 2.6.27-rc2 when cross-building the kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my i386 systems used just for testing can take up to 18 hours 
to build a new kernel with about 200 modules. When performing a 
bisection, this gets rather tedious. As a result, I moved the kernel 
sources to an NFS volume, do the majority of the work as a cross-build 
on my x86_64 computer, and only switch to the slow machine to install 
the kernel and modules. Somewhere between 2.6.27-rc1 and -rc2, the 
module installation broke because the build leaves 
scripts/basic/fixdep as a 64-bit program that will not run on the 
32-bit system. Once I get to the i386 machine, I delete the two 
programs from scripts/basic/, manually rebuild them with a 'make 
scripts/basic/' and then do the final 'make modules_install install'.

Larry
