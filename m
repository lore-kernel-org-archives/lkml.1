Return-Path: <linux-kernel-owner+w=401wt.eu-S935360AbXHOSRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935360AbXHOSRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbXHOSRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:17:02 -0400
Received: from wa-out-0708.google.com ([209.85.146.249]:45106 "EHLO
	wa-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbXHOSRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:17:00 -0400
X-IP: 90.157.192.193
From: david.balazic@hermes-softlab.com
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per device dirty throttling -v8
Date: Wed, 15 Aug 2007 11:16:52 -0700
Message-ID: <1187201812.396804.76130@k79g2000hse.googlegroups.com>
In-Reply-To: <fa.uq0BQtrgp66a08hpsF+vrqXUNC4@ifi.uio.no>
References: <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org>
   <fa.7rstQpXif2z9y2n2HD+qxLFnueg@ifi.uio.no>
   <fa.6VOZrceT65Vh8CIRIta0zSg2V38@ifi.uio.no>
   <fa.xcZCTa5cHDOhrcyXZ2gZbzbu7g0@ifi.uio.no>
   <fa.JjZwG90x+07YaOx8h5VLN+9AL/8@ifi.uio.no>
   <fa.V9U4mAEXVjNqblhzu7GRmxif7Uw@ifi.uio.no>
   <fa.uq0BQtrgp66a08hpsF+vrqXUNC4@ifi.uio.no>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (Windows; U; Windows NT 5.2; en-US; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6,gzip(gfe),gzip(gfe)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 4, 10:15 pm, Arjan van de Ven <ar...@infradead.org> wrote:
> On Sat, 2007-08-04 at 12:47 -0700, Linus Torvalds wrote:
>
> > On Sat, 4 Aug 2007, Jörn Engel wrote:
>
> > > Given the choice between only "atime" and "noatime" I'd agree with you.
> > > Heck, I use it myself.  But "relatime" seems to combine the best of both
> > > worlds.  It currently just suffers from mount not supporting it in any
> > > relevant distro.
>
> > Well, we could make it the default for the kernel (possibly under a
> > "fast-atime" config option), and then people can add "atime" or "noatime"
> > as they wish, since mount has supported _those_ options for a long time.
>
> there is another trick possible (more involved though, Al will have to
> jump in on that one I suspect): Have 2 types of "dirty inode" states;
> one is the current dirty state (meaning the full range of ext3
> transactions etc) and "lighter" state of "atime-dirty"; which will not
> do the background syncs or journal transactions (so if your machine
> crashes, you lose the atime update) but it does keep atime for most
> normal cases and keeps it standard compliant "except after a crash".

Am I one of the few that thinks this would be a win-win solution ? :-(
I guess it requires a lot more coding than relatime.

Regards,
David Balažic

