Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYCKWoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYCKWoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYCKWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:44:08 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:11772 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbYCKWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:42:07 -0400
Date: Tue, 11 Mar 2008 23:42:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: akpm@osdl.org, wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Terminate hugetlbfs mount argument list
Message-ID: <20080311224204.GA16719@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Mar 2008 22:35:32.0673 (UTC) FILETIME=[376E4310:01C883C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Terminate hugetlbfs mount argument list

[2.6.25 candidate I believe]

The match_table_t for the mount arguments in hugetlbfs wasn't 
terminated as match_tokens expect. I didn't see a crash just code
audit, but it's still safer to terminate it in case the variables after
that in .data are not NULL.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/fs/hugetlbfs/inode.c
===================================================================
--- linux.orig/fs/hugetlbfs/inode.c
+++ linux/fs/hugetlbfs/inode.c
@@ -63,6 +63,7 @@ static match_table_t tokens = {
 	{Opt_uid,	"uid=%u"},
 	{Opt_gid,	"gid=%u"},
 	{Opt_err,	NULL},
+	{},
 };
 
 static void huge_pagevec_release(struct pagevec *pvec)
