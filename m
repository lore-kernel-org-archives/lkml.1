Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbZKFUgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbZKFUgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759821AbZKFUgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:36:06 -0500
Received: from mail2.shareable.org ([80.68.89.115]:41234 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815AbZKFUgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:36:03 -0500
Date: Fri, 6 Nov 2009 20:36:01 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] proc: revalidate dentry returned by proc_pid_follow_link
Message-ID: <20091106203601.GD27751@shareable.org>
References: <1257513594-31071-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257513594-31071-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton wrote:
> The problem here is that this makes that code shortcut any lookup or
> revalidation of the dentry. In general, this isn't a problem -- in most
> cases the dentry is known to be good. It is a problem however for NFSv4.
> If this symlink is followed on an open operation no actual open call
> occurs and the open state isn't properly established. This causes
> problems when we later try to use this file descriptor for actual
> operations.

As NFS uses open() as a kind of fcntl-lock barrier, I can see it's
important to do _something_ on new opens, rather than just cloning
most of the file descriptor.

> This patch takes a minimalist approach to fixing this by making the
> /proc/pid follow_link routine revalidate the dentry before returning it.

What happens if the file descriptor you are re-opening is for a file
which has been deleted.  Does it still have a revalidatable dentry?

-- Jamie
