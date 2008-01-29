Return-Path: <linux-kernel-owner+w=401wt.eu-S1765412AbYA2QPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765412AbYA2QPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763920AbYA2QPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:15:24 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43681 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762982AbYA2QPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:15:23 -0500
Message-Id: <20080129160229.612172683@bull.net>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jan 2008 17:02:29 +0100
From: pierre.peiffer@bull.net
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 2.6.24-rc8-mm1 00/15] IPC: code rewrite + new functionalities
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:24:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 29/01/2008 17:24:03,
	Serialize complete at 29/01/2008 17:24:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

	Here is a patchset about the IPC, which proposes to consolidate some
part of the existing code and to add some functionalities.

* Patches 1 to 8 don't change the existing behavior, but propose to rewrite
some parts of the existing code. In fact, the three kinds of IPC (semaphores,
message queues and shared memory) have some common commands (IPC_SET, IPC_RMID,
etc...) but they are mainly handled in three different ways. These patches
propose to consolidate this, by handling these commands the same way and try
to use, as much as possible, some common code. This should increase
readability and maintainability of the code, making them probably good
candidate for the -mm tree, I think.

* Patches 9 to 15 propose to add some functionalities, and thus are
submitted here for RFC, about both the interest and their implementation.
These functionalities are:
    - Two new control-commands:
	. IPC_SETID: to change an IPC's id.
	. IPC_SETALL: behaves as IPC_SET, except that it also sets all time
	  and pid values)
    - add a /proc/<pid>/semundo file to read and write the undo values of
some semaphores for a given process.

	As the namespaces and the "containers" are being integrated in the
kernel, these functionalities may be a first step to implement  the
checkpoint/restart of an application: in fact the existing API does not allow
to specify or to change an ID when creating an IPC, when restarting an
application, and the times/pids values of each IPCs are also altered. May be
someone may find another interest about this ?

So again, comments are welcome.

Thanks.

-- 
Pierre
