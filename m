Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZCGSJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZCGSJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZCGSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:09:44 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37053 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZCGSJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:09:43 -0500
Date: Sat, 7 Mar 2009 10:08:16 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: serue@us.ibm.com, hpa@zytor.com, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5][v2] Simplify devpts code
Message-ID: <20090307180816.GA30072@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset tries to address Christoph Hellwig's review comments on the
support for multiple-instances in devpts.  http://lkml.org/lkml/2009/1/3/84
It breaks up the patch into smaller pieces for (hopefully)  easier review.

IIUC, the key observation was that most of do_remount_sb() (MS_RDONLY flag
and shrink_dcache() does not apply to devpts and only the parsing of
options does. Moving the parsing code into devpts enables us to parse
the options just once and vastly simplifies the code.

This patchset does not change any functionality/behavior. But it does
depend on following two related patches.

	http://lkml.org/lkml/2009/1/29/10
	http://lkml.org/lkml/2009/1/29/11

Patches in this set:

	[PATCH 1/5] Unroll essentials of do_remount_sb() into devpts
	[PATCH 2/5] Parse mount options just once and copy them to super block
	[PATCH 3/5] Move common mknod_ptmx() calls into caller
	[PATCH 4/5] Remove get_init_pts_sb()
	[PATCH 5/5] Merge code for single and multiple-instance mounts

Changelog[v3]:
	- (Serge Hallyn): Remove unnecessary printks

Changelog[v2]:
	- (Christoph Hellwig) Patch 2/5 remove '//check' comment. Initialized
	  object using memset().
	- (Christoph Hellwig) - Patch 5/5; Removed the do_pts_mount() function
	   and moved that code into devpts_get_sb()

TODO: (Independent patch set)

	- Merge CONFIG_DEVPTS_MULTIPLE_INSTANCES token with other container-
	  related tokens ? 
