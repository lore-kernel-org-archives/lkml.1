Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbYCFA2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbYCFA2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbYCFA2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:28:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:61181 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYCFA2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:28:10 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mark.fasheh@oracle.com
Subject: [PATCH 0/18] ocfs2: Cluster stack glue layer
Date: Wed,  5 Mar 2008 16:27:23 -0800
Message-Id: <1204763261-28025-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2 is currently tied to its internal cluster stack, the ocfs2 Cluster
Base (o2cb).  This includes the nodemanager (o2nm) and distributed lock
manager (o2dlm).

Going forward, ocfs2 would like to use the DLM in fs/dlm.  This includes
interacting with userspace cluster stacks that drive fs/dlm, allowing
all clustering on a machine to use the same stack.

This patch series decouples the o2cb stack from ocfs2, creating a
plug-in architecture.  A layer called "stackglue" sits between the ocfs2
filesystem and the chosen cluster plug-in.  A later patch series will
introduce the plug-in for fs/dlm and userspace cluster stacks.

The series should be functionally equivalent.  Each patch should compile
and run successfully, with no modification to userspace tools.  The end
result of this series is a plug-in cluster backend that behaves exactly
as the current system does.  As an added benefit, local (non-clustered)
ocfs2 filesystems do not need to load any plug-in.  In the past, even a
non-clustered filesystem required the o2cb modules loaded, though not
configured.

The kernel code is also available on the 'stack-glue' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=stack-glue
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git stack-glue


