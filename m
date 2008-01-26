Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYAZFjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYAZFjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYAZFjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:39:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752768AbYAZFjl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:39:41 -0500
Date: Sat, 26 Jan 2008 16:39:28 +1100
From: David Chinner <dgc@sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3 freeze feature
Message-ID: <20080126053928.GO155407@sgi.com>
References: <20080125195938t-sato@mail.jp.nec.com> <20080126053526.GN155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126053526.GN155407@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 04:35:26PM +1100, David Chinner wrote:
> On Fri, Jan 25, 2008 at 07:59:38PM +0900, Takashi Sato wrote:
> > The points of the implementation are followings.
> > - Add calls of the freeze function (freeze_bdev) and
> >   the unfreeze function (thaw_bdev) in ext3_ioctl().
> > 
> > - ext3_freeze_timeout() which calls the unfreeze function (thaw_bdev)
> >   is registered to the delayed work queue to unfreeze the filesystem
> >   automatically after the lapse of the specified time.
> 
> Seems like pointless complexity to me - what happens if a
> timeout occurs while the filsystem is still freezing?
> 
> It's not uncommon for a freeze to take minutes if memory
> is full of dirty data that needs to be flushed out, esp. if
> dm-snap is doing COWs for every write issued....

Sorry, ignore this bit - I just realised the timer is set
up after the freeze has occurred....

Still, that makes it potentially dangerous to whatever is being
done while the filesystem is frozen....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
