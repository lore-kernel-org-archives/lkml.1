Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbYEFJEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbYEFJEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762313AbYEFI4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:56:49 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45384 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763440AbYEFI4r (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:56:47 -0400
Date: Tue, 6 May 2008 18:56:32 +1000
From: David Chinner <dgc@sgi.com>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Message-ID: <20080506085632.GT155679365@sgi.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 09:03:06AM +0200, Marco Berizzi wrote:
> David Chinner wrote:
> > > May  5 14:31:38 Pleiadi kernel: xfs_inactive:^Ixfs_ifree() returned
> an
> > > error = 22 on hda8
> >
> > Is it reproducable?
> 
> honestly, I don't know. As you may see from the
> dmesg output this box has been started on 24 april
> and the crash has happened yesterday.

Yeah, I noticed that it happened after substantial uptime.

> IMHO the crash happended because of this:
> At 12:23 squid complain that there is no left space
> on device, and it start to shrinking cache_dir, and
> at 12:57 the kernel start logging...
> This box is pretty slow (celeron) and the hda8 filesystem
> is about 2786928 1k-blocks.

Hmmmmm - interesting. Both the reports of this problem are from
machines running as squid proxies. Are you using AUFS for the cache?

Interesting the ENOSPC condition, but I'm not sure it is at all
relevant - the other case seemed to be triggered by some cron job
doing cache cleanup so I think it's just the removal files that is
triggering this....

> > What were you doing at the time the problem occurred?
> 
> this box is running squid (http proxy): hda8 is where
> squid cache and logs are stored.
> I haven't rebooted this box since the problem happened.
> If you need ssh access just email me.
> This is the output from xfs_repair:

You've run repair, there's not much I can look at now.

As a suggestion, when the cache gets close to full next time, can
you take a metadump of the filesystem (obfuscates names and contains
no data) and then trigger the cache cleanup function? If the
filesystem falls over, I'd be very interested in getting a copy of
hte metadump image and trying to reproduce the problem locally.
(BTW, you'll need a newer xfsprogs to get xfs_metadump).

Still, thank you for the information - the bit about squid proxies
if definitely relevant, I think...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
