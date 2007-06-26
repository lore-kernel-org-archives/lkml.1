Return-Path: <linux-kernel-owner+w=401wt.eu-S1762580AbXFZX2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580AbXFZX2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760758AbXFZXQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:16:24 -0400
Received: from ns.suse.de ([195.135.220.2]:43532 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbXFZXQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:16:21 -0400
Message-Id: <20070626231510.883881222@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:15:10 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFD 0/4] AppArmor - Don't pass NULL nameidata to vfs_create/lookup/permission IOPs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 

This post is a request for discussion on creating a second smaller
nameidata struct to eliminate conditionally passing of vfsmounts
to the LSM.

It contains a series of patches that apply on top of the AppArmor
patch series.  These patches were previously post on May 14,
but received no feedback.  Any and all feedback is welcome so
that we can improve these patches or replace them with a better
solution if one presents it self.

To remove conditionally passing of vfsmounts to the LSM, a nameidata
struct can be instantiated in the nfsd and mqueue filesystems.  This
however results in useless information being passed down, as not
all fields in the nameidata struct will be meaingful.  The nameidata
struct is split creating struct nameidata2 that contains only the fields
that will carry meaningful information.

The creation of the nameidata2 struct raises the possibility of
replacing the current dentry, vfsmount argument pairs in the
vfs and lsm patches with a single nameidata2 argument although these
patches do not currently do this.

A tarball of these patches and the AppArmor kernel patches  are
available at:

  http://forgeftp.novell.com//apparmor/LKML_Submission-June-07/
