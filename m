Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751780AbYLQRzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbYLQRzb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYLQRzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:55:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:54968 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbYLQRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:55:20 -0500
Date: Wed, 17 Dec 2008 11:55:13 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux Containers <containers@lists.osdl.org>
Subject: [RFC patch 0/2] posix mqueue namespace (v12)
Message-ID: <20081217175513.GA23291@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posix message queue support in ipc namespaces has had
several submissions by various people.  Hopefully this
version, based on code by both Cedric Le Goater and
Nadia Derbey has a shot at making it upstream.

To create a new ipc namespace with posix mq support, you
would

	unshare(CLONE_NEWIPC|CLONE_NEWNS);
	umount /dev/mqueue
	mount -t mqueue mqueue /dev/mqueue

It's perfectly valid to do vfs operations on files
in another ipc_namespace's /dev/mqueue, but any use
of mq_open(3) and friends will act in your own ipc_ns.

thanks,
-serge
