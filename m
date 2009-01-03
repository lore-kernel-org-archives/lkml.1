Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbZACJoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbZACJoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 04:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZACJoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 04:44:21 -0500
Received: from sh.osrg.net ([192.16.179.4]:48138 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbZACJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 04:44:19 -0500
Date: Sat, 03 Jan 2009 18:44:06 +0900 (JST)
Message-Id: <20090103.184406.54858118.ryusuke@osrg.net>
To: Chris Mason <chris.mason@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: Btrfs for mainline
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1230925087.7538.41.camel@think.oraclecorp.com>
References: <1230765549.7538.8.camel@think.oraclecorp.com>
	<20090103.013755.42849152.ryusuke@osrg.net>
	<1230925087.7538.41.camel@think.oraclecorp.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jan 2009 14:38:07 -0500, Chris Mason <chris.mason@oracle.com> wrote:
> On Sat, 2009-01-03 at 01:37 +0900, Ryusuke Konishi wrote:
> > In addition, there seem to be well-separated reusable routines such as
> > async-thread (enhanced workqueue) and extent_map.  Do you intend to
> > move these into lib/ or so?
> 
> Sorry, looks like I hit send too soon that time.  The async-thread code
> is very self contained, and was intended for generic use.  Pushing that
> into lib is probably a good idea.

As for async-thread, kernel/ seems to be better place (sorry, I also hit
send too soon ;)

Anyway, I think it should be reviewed deeply by scheduler people and
wider range of people.  So, it's a good idea to put it out in order to
arouse interest.
 
> The extent_map and extent_buffer code was also intended for generic use.
> It needs some love and care (making it work for blocksize != pagesize)
> before I'd suggest moving it out of fs/btrfs.
> 
> -chris

The extent_map itself seemed independent of the problem to me, but I
understand your plan.

Btrfs seems to have other helpful code including pages/bio compression
which may become separable, too.  And, this may be the same for
pages/bio encryption/decryption code which would come next.  (I don't
mention about the volume management/raid feature here to avoid getting
off the subject, but it's likewise).

I think it's wonderful if they can be well-integrated into sublayers
or libraries.

Regards,
Ryusuke
