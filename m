Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYLPLiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYLPLiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbYLPLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:37:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:54841 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414AbYLPLhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:37:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject;
	b=hA96H3xoXWclCYzsdeiqr28zqSwh95CWsaJrHA0gKwgtQdjMHUyTsZS9FKo0N8ApP
	IJQVIcDy+asU4NTQuOmTg==
Message-Id: <20081216113055.713856000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 16 Dec 2008 03:30:55 -0800
From: menage@google.com
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] CGroups: Hierarchy locking/refcount changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce new locking/refcount support for cgroups to
reduce the need for subsystems to call cgroup_lock(). This will
ultimately allow the atomicity of cgroup_rmdir() (which was removed
recently) to be restored.

These three patches give:

1/3 - introduce a per-subsystem hierarchy_mutex which a subsystem can
     use to prevent changes to its own cgroup tree

2/3 - use hierarchy_mutex in place of calling cgroup_lock() in the
     memory controller

3/3 - introduce a css_tryget() function similar to the one recently
      proposed by Kamezawa, but avoiding spurious refcount failures in
      the event of a race between a css_tryget() and an unsuccessful
      cgroup_rmdir()

Future patches will likely involve:

- using hierarchy mutex in place of cgroup_lock() in more subsystems
 where appropriate

- restoring the atomicity of cgroup_rmdir() with respect to cgroup_create()

Signed-off-by: Paul Menage <menage@google.com>

--
