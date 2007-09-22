Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbXIVLYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbXIVLYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 07:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXIVLYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 07:24:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51837 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbXIVLYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 07:24:34 -0400
Date: Sat, 22 Sep 2007 13:24:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: sam@ravnborg.org, zippel@linux-m68k.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Unfortunate infinite make recursion
Message-ID: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


You can cause a recursion in kbuild/make with the following:

make O=$PWD kernel/time.o
make mrproper

Of course no one would use O=$PWD (that's just the testcase),
but this happened too often:

/ws/linux/linux-2.6.23$ make O=/ws/linux/linux-2.6.23 kernel/time.o
(Oops - should have been O=/ws/linux/obj-2.6.23!)

The make O=$PWD truncates the Makefile, making it necessary to run `git 
checkout Makefile` - should you have git; or reextract the tarball 
(should you /still/ have it). Well, can we catch this case somehow?


thanks,
Jan
