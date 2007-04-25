Return-Path: <linux-kernel-owner+w=401wt.eu-S1422941AbXDYXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422941AbXDYXd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422973AbXDYXd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 19:33:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48599 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422941AbXDYXd4 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 19:33:56 -0400
Date: Thu, 26 Apr 2007 09:33:45 +1000
From: David Chinner <dgc@sgi.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
Message-ID: <20070425233345.GN48531920@melbourne.sgi.com>
References: <200704251116.57737.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704251116.57737.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:16:57AM +0200, Jesper Juhl wrote:
> 
> Hi,
> 
> For your information : 
> 
> Once in a while I see the message below after I've just created a new XFS filesystem, mount it and then start copying data to it.

.....

> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.20.3generic #1
> ---------------------------------------------
> xfs_fsr/6117 is trying to acquire lock:
>  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
> 
> but task is already holding lock:
>  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]

Known false positive - XFS doesn't have the annotations needed for
this yet; we've got a patch that will probably make it's way into 6.5.22 that
should fix most of these issues.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
