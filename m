Return-Path: <linux-kernel-owner+w=401wt.eu-S968585AbXG3UMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968585AbXG3UMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764057AbXG3UMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:12:05 -0400
Received: from aug.linbit.com ([212.69.162.22]:60596 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965988AbXG3UMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:12:03 -0400
X-Greylist: delayed 2179 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 16:12:03 EDT
Date: Mon, 30 Jul 2007 21:35:33 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Jens Axboe <axboe@kernel.dk>,
       Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070730192954.GA7363@localhost>
Mail-Followup-To: Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Machek <pavel@ucw.cz>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20070721203819.GA10706@mail.linbit.com> <Pine.LNX.4.64.0707212316530.21737@fbirervta.pbzchgretzou.qr> <20070721224300.GB18326@mail.linbit.com> <20070727184617.GF11895@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727184617.GF11895@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 06:46:17PM +0000, Pavel Machek wrote:
> Hi!
> 
> > > >We implement shared-disk semantics in a shared-nothing cluster.
> > > 
> > > If nothing is shared, the disk is not shared, but got shared-disk
> > > semantics? A little confusing.
> > 
> > Think of it as RAID1 over TCP.
> > Typically you have one Node in Primary, the other as Secondary,
> > replication target only.
> 
> I guess TCP means people should not swap over it?

people should not swap over DRBD,
because it would not be useful.

DRBD is to have applicaction data available for more than one node,
without a single point of failure; when the node the app currently runs
on crashes, the data is there so some other node can take over from there.

what would you do with the swap of a crashed node, apart from,
well, crash analysis?
you don't need it to be highly available for that.

besides, yes, when you have network io in the block io path,
with linux (and probably most other OSes),
there is the posibility of vm starvation or even deadlock.

situation is improving, though - iirc, there has been talk to
have a emergency memory pool very low level in the network stack,
and some special "I am doing block-io" socket flag;
what is the status of that, anyone?

I belive DRBD behaves very good even in oom situations.
we considered these things from the very beginning.

that said,
I did not see a DRBD cluster hanging hard in OOM, yet.
and we do operate quite a few busy
database/mail/web/file/application/iSCSI/whatever clusters.

	Lars

