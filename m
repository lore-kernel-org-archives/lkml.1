Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752349AbYLQVG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbYLQVG1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYLQVGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:06:17 -0500
Received: from sandeen.net ([209.173.210.139]:20120 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYLQVGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:06:16 -0500
Message-ID: <494969C6.4090500@sandeen.net>
Date: Wed, 17 Dec 2008 15:06:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.com>
CC: Ankit Jain <me@ankitjain.org>, linux-kernel@vger.kernel.org,
        joel.becker@oracle.com, Christoph Hellwig <hch@infradead.org>,
        xfs-masters@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        ocfs2-devel@oss.oracle.com
Subject: Re: [xfs-masters] [PATCH][RFC] fs: Add new pre-allocation ioctls
 to vfs for compatibility with legacy xfs ioctls
References: <49460F88.2080408@ankitjain.org> <20081217202815.GE8791@wotan.suse.de>
In-Reply-To: <20081217202815.GE8791@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Fasheh wrote:
> On Mon, Dec 15, 2008 at 01:34:24PM +0530, Ankit Jain wrote:
>> This patch adds ioctls to vfs for compatibility with legacy XFS
>> pre-allocation ioctls (XFS_IOC_*RESVP*). The implementation
>> effectively invokes sys_fallocate for the new ioctls.
>> Note: These legacy ioctls are also implemented by OCFS2.
>>
>> There are some things that I'm not sure about:
>> 1. Should the struct space_resv be exposed to user-space? If not,
>> then what would be the right place to put it? And the ioctl
>> definitions?
> 
> Yes. As far as where to put it, I'm not sure. Maybe falloc.h?

I'd sort of rather not; why should that legacy struct space_resv be
available in a header... I thought this was for people already using the
xfs ioctl, in which case they are already using the xfs header... and if
they want preallocation in any new work, they should use fallocate()
instead, yes?

I mean it wouldn't hurt anything but it sort of confuses the interface
story IMHO.

-Eric
