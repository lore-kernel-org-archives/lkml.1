Return-Path: <linux-kernel-owner+w=401wt.eu-S1764847AbYD0XXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764847AbYD0XXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYD0XXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:23:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41412 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbYD0XXc (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:23:32 -0400
Date: Mon, 28 Apr 2008 09:23:17 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_page_state_convert()
Message-ID: <20080427232317.GB103491721@sgi.com>
References: <200804270246.58828.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804270246.58828.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 02:46:58AM +0200, Denys Vlasenko wrote:
> Hi David,
> 
> This patch reduces xfs_page_state_convert() stack usage by 16 bytes
> by eliminating some local variables, and reducing the size
> of scope for other locals.
> 
> Compile tested only.

Can you start testing your patches? if you are touching the writeback
or allocator path, there's a pretty high barrier to having patches
excepted, and testing them before is one of them. Go and download the
XFSQA suite from the xfs-cmds CVS tree on oss.sgi.com, and run your
patches through it....

> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> 
> P.S.
> 
> xfs_page_state_convert() carries the following comment:
>  * Calling this without startio set means we are being asked to make a dirty
>  * page ready for freeing it's buffers.  When called with startio set then
>  * we are coming from writepage.
> which leads to the following proposal: reimplement it as two
> functions, one which work as if startio parameter == 0
> and the other as if startio == 1.
> This will result in a bit of code duplication, but reduces
> stack usage on writepage path and allows for these two functions
> to have more descriptive names. (Presently the meaning of this
> function needs to be explained in that comment -> function
> name is not descriptive enough, because it does different things
> depending on startio value).
> 
> Do you like this idea?

No. That code is complex enough with only one copy of it around. I don't
want two copies that differ subtly and hence have two different sets
of nasty, rarely hit corner cases in them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
