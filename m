Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZJPVqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZJPVqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZJPVqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:46:14 -0400
Received: from lucidpixels.com ([75.144.35.66]:40249 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZJPVqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:46:13 -0400
Date: Fri, 16 Oct 2009 17:46:18 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 3ware 9650SE-4PML RAID-1 Question: One reader process starves I/O
 to the rest of the system?
Message-ID: <alpine.DEB.2.00.0910161741110.11211@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried CFQ/deadline schedulers, when I run the following:

# /usr/bin/time dd if=/dev/sdb2 of=/raid6/sdb2.img

Behind which are 2 x Raptor 150GB disks, the system is pretty much unusable
when I control-c the dd, it comes back to life.

The RAID-6 is a 15-disk RAID-6 which does 600-700MB/s writes.

All cards are on PCI-e and have adequate bandwidth on a P55 board (DP55KG).

Are there any recommended tuning options for a RAID-1 configuration, such that
a heavy I/O read or write operation does not pause the system?

During the dd..

Drive Performance Monitor Configuration for /c1 ...
Performance Monitor: ON
Version: 1
Max commands for averaging: 100
Max latency commands to save: 10
Requested data: Instantaneous Drive Statistics

                                Queue           Xfer         Resp
Port   Status           Unit   Depth   IOPs    Rate(MB/s)   Time(ms)
------------------------------------------------------------------------
p0     OK               u0     25      762     26.219       19 
p1     OK               u0     23      780     25.953       24 
p2     OK               u1     1       0       0.000        98 
p3     NOT-PRESENT      -      -       -       -            -

Justin.


