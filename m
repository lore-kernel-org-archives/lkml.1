Return-Path: <linux-kernel-owner+w=401wt.eu-S932415AbZEAUB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbZEAUB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765019AbZEAUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:01:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764998AbZEAUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:01:28 -0400
Date: Fri, 1 May 2009 12:56:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       viro@ftp.linux.org.uk, a.beregalov@gmail.com, david@unsolicited.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
Message-Id: <20090501125627.e13ff38f.akpm@linux-foundation.org>
In-Reply-To: <49FB1F20.8040400@suse.com>
References: <49FB1F20.8040400@suse.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 May 2009 12:11:12 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

>  2.6.30-rc3 introduced some sanity checks in the VFS code to avoid NFS
>  bugs by ensuring that lookup_one_len is always called under i_mutex.
> 
>  This patch expands the i_mutex locking to enclose lookup_one_len. This was
>  always required, but not not enforced in the reiserfs code since it
>  does locking around the xattr interactions with the xattr_sem.

cool, so this will fix all those backtraces people have been reporting
coming out of the reiserfs xattr code lately?

>  This is obvious enough, but it survived an overnight 50 thread ACL test.

That sounds a bit pessimistic.  I think I'll s/but/and/ ;)
