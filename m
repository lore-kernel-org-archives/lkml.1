Return-Path: <linux-kernel-owner+w=401wt.eu-S1755773Ab0AFKFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0AFKFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725Ab0AFKFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:05:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:59307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab0AFKFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:05:37 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: linux-kernel@vger.kernel.org
Subject: make firmware_install pollutes $(objtree) with files owned by root
Date: Wed, 6 Jan 2010 15:36:25 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: David Woodhouse <David.Woodhouse@intel.com>, Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001061536.25576.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

`make firmware_install` has to be run as root, so that the firmware could be 
installed in /lib/firmware. But it doesn't simply install firmware from the 
object directory. It first copies/converts files from source directory to the 
object directory, which then gets installed.

This leads to the situation where `make clean` cannot be run as normal user as 
he cannot remove files belonging to root. It would be a common expectaion to 
be able to delete the source/object tree as user.

We should introduce another make target, `make firmware` to convert/copy files 
from src dir to obj dir. Or this intermediate step should be avoided. Or 
atleast `make firmware_install` should delete the files it created in the 
object tree.

Thanks
Nikanth
