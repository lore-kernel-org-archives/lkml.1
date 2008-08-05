Return-Path: <linux-kernel-owner+w=401wt.eu-S1763358AbYHEXoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763358AbYHEXoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYHEXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:44:16 -0400
Received: from [116.90.133.99] ([116.90.133.99]:49099 "EHLO mars.unix.geek.nz"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYHEXoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:44:15 -0400
Subject: Re: XFS noikeep remount in 2.6.27-rc1-next-20080730
From: Jasper Bryant-Greene <jasper@amiton.co.nz>
To: Dave Chinner <david@fromorbit.com>
Cc: Karel Zak <kzak@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       util-linux-ng@vger.kernel.org
In-Reply-To: <20080805233956.GI21635@disturbed>
References: <1217553598.3860.16.camel@luna.unix.geek.nz>
	 <20080801073033.GF6201@disturbed> <20080801193133.GA838@lst.de>
	 <20080805110357.GL21873@nb.net.home>  <20080805233956.GI21635@disturbed>
Content-Type: text/plain
Organization: Amiton Ltd
Date: Wed, 06 Aug 2008 11:44:22 +1200
Message-Id: <1217979862.2887.39.camel@luna.unix.geek.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 09:39 +1000, Dave Chinner wrote:
> We're seeing the second case where mount is merging all the options in
> /etc/fstab into the options passed into the remount command. How is
> the filesystem expected to behave in these difference cases? The
> first simply changes the ro/rw status, the second potentially
> asks for the filesystem to change a bunch of other mount options
> as well, which it may not be able to do.
> 
> So what is the correct behaviour? Should the filesystem *silently
> ignore* unchangable options in the remount command, or should it
> fail the remount and warn the user that certain options are not
> allowed in remount?

(forgive me, I'm an XFS user, not an XFS developer, so this might be
ignorant)

The filesystem presumably knows what options it was originally mounted
with.

Thus if you take the difference of the set of options you were mounted
with, and the set of options you are now being asked to remount with,
you have the options which are being asked to change.

If changing any of them is unsupported I would expect an error, but in
this case the result of taking the above set difference would be merely
replacing ro with rw, and thus the filesystem is presumably capable of
doing the remount.

-jasper

