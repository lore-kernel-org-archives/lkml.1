Return-Path: <linux-kernel-owner+w=401wt.eu-S965581AbXA3PFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581AbXA3PFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXA3PFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:05:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965581AbXA3PFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:05:18 -0500
Message-ID: <45BF5E68.4070000@redhat.com>
Date: Tue, 30 Jan 2007 10:04:08 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Kirill Korotaev <dev@openvz.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] have pipefs ensure i_ino uniqueness by calling iunique
 and hashing the inode
References: <200612291911.kBTJBLvx019107@dantu.rdu.redhat.com> <45B9F939.8070701@openvz.org> <45BA1359.7020200@redhat.com> <200701261612.52414.dada1@cosmosbay.com>
In-Reply-To: <200701261612.52414.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
 >
 > For dentry name, we certainly could use "[address of inode]" instead
 > of "[inode number]" to get unicity, but do we care ?
 >
 > For st_ino values on pipefs and sockets, I doubt any user application would
 > care. I never had to fstat() a socket fd. Of course it's a file descriptor,
 > but all we really want to do with this kind of file descriptor is to call
 > socket API.
 >
 > And for some heavy loaded internet servers , the additional cost of
 > insert/delete a node in a machine shared tree could be a problem.
 >

Granted, I've never had to stat a pipe fd either, so maybe in the big scheme
of things, it's not that important. Still, I think we can probably do this
without a great deal of added complexity or performance impact.

If changing the stuff between the brackets in the dentry name to something
besides inode number is OK, then we can defer the assignment of the inode
number until it's actually needed. For pipefs calls, this means we can only
assign an inode number when a stat call is actually done. So anyone who needs
that info can get it, and anyone who doesn't care about it shouldn't be
greatly impacted by it.

I'll be following up this email with a couple of patches for comment...

-- Jeff

