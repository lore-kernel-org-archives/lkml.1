Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbYDOVLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbYDOVLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762945AbYDOVLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:11:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759043AbYDOVLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:11:12 -0400
Date: Tue, 15 Apr 2008 14:04:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, containers@lists.osdl.org
Subject: Re: [PATCH 1/2] eCryptfs: Introduce device handle for userspace
 daemon communications
Message-Id: <20080415140453.a45a15b4.akpm@linux-foundation.org>
In-Reply-To: <20080415202313.GM4627@localhost.austin.ibm.com>
References: <20080415202313.GM4627@localhost.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008 15:23:13 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> Functions to facilitate reading and writing to the eCryptfs
> miscellaneous device handle. This will replace the netlink interface
> as the preferred mechanism for communicating with the userspace
> eCryptfs daemon.
> 
> Each user has his own daemon, which registers itself by opening the
> eCryptfs device handle. Only one daemon per euid may be registered at
> any given time. The eCryptfs module sends a message to a daemon by
> adding its message to the daemon's outgoing message queue. The daemon
> reads the device handle to get the oldest message off the queue.
> 
> Incoming messages from the userspace daemon are immediately
> handled. If the message is a response, then the corresponding process
> that is blocked waiting for the response is awakened.
> 

This is a drastic change, but the changelog doesn't tell us why it is being
made!

> ...
> +	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid);
> +	if (daemon->pid != current->pid) {
> +	rc = ecryptfs_find_daemon_by_euid(&daemon, current->euid);
> +	BUG_ON(current->euid != daemon->euid);
> +	BUG_ON(current->pid != daemon->pid);

This code uses pids and uids all over the place.  Will it operate correctly
in a containerised environment?

