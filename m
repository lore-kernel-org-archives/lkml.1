Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752885AbYLRSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYLRSAc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 13:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLRSAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 13:00:22 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:38300 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYLRSAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 13:00:21 -0500
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Make lockdep happy with configfs
Date: Thu, 18 Dec 2008 19:00:16 +0100
Message-Id: <1229623218-8056-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218111536.GR19128@hawkmoon.kerlabs.com>
References: <20081218111536.GR19128@hawkmoon.kerlabs.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Here is a patchset implementing a more lockdep-friendly solution to make lockdep
happy with configfs.

The first patch could probably be cleaner, but first let's see if the
approach is ok.
I don't have a good setup to test the second patch beyond compilation, but I
guess that Joel has one :)

So, does it look better?

Louis

Louis Rilling (2):
      configfs: Silence lockdep on mkdir() and rmdir()
      configfs: Rework configfs_depend_item() locking and make lockdep happy

 fs/configfs/configfs_internal.h |    3 +
 fs/configfs/dir.c               |  131 +++++++++++++++++++++++----------------
 fs/configfs/inode.c             |   28 ++++++++
 3 files changed, 108 insertions(+), 54 deletions(-)
-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
