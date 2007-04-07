Return-Path: <linux-kernel-owner+w=401wt.eu-S965961AbXDGWr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965961AbXDGWr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 18:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXDGWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 18:47:29 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:46343 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbXDGWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 18:47:28 -0400
Date: Sat, 7 Apr 2007 18:47:20 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: aeb@cwi.nl
cc: linux-kernel@vger.kernel.org
Subject: [RFC] partitions: CONFIG_BLK_DEV_MD and modular RAID support
Message-ID: <alpine.DEB.0.83.0704071836060.19488@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Linux v2.6.20.6.)

The function md_autodetect_dev is defined in drivers/md/md.c. Its 
declaration is on line 1443, outside of conditionals. However, both its 
use on line 1455 and its definition on line 5600 are inside "#ifndef 
MODULE" conditionals. So it seems obvious that the declaration should be 
inside conditionals as well.

However, this function is separately declared and used in 
fs/partitions/check.c but not inside the same conditional, which means if 
md.c is compiled as a module, check.c will be referencing an undefined 
symbol.

Should the conditionals around md_autodetect_dev be changed to make sure 
CONFIG_BLK_DEV_MD=y, or does the function need to be extracted from md.c 
so it can be used by check.c in any case?
