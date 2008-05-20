Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbYETQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbYETQv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933083AbYETQuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:50:32 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:60685 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbYETQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:50:29 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 12:50:11 EDT
Message-Id: <20080520163320.025971210@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 May 2008 18:33:20 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [RFC][PATCH 0/3] configfs: Make nested default groups lockdep-friendly
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following patches fix lockdep warnings resulting from (correct) recursive
locking in configfs.

Current lockdep annotations for inode mutexes in configfs are lockdep-friendly
provided that:
1/ config_groups have at most one level of default groups (see
   configfs_attach_group()),
2/ config_groups having default groups are never removed (see
   configfs_detach_prep()).

Since lockdep does not handle such correct recursion, the idea is to insert
lockdep_off()/lockdep_on() for inode mutexes as soon as the level of recursion
of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency pattern increases.

The patches apply to latest configfs in linux-2.6.git (
commit 8033c6e9736c29cce5f0d0abbca9a44dffb20c39 for instance ), and were
successfully tested.

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

