Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYJTD63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYJTD63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYJTD6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:58:20 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:53693 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751453AbYJTD6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:58:20 -0400
From: swivel@shells.gnugeneration.com
Date: Sun, 19 Oct 2008 22:58:19 -0500
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
Message-ID: <20081020035819.GG2811@fc6222126.aspadmin.net>
References: <20081005.153059.111120997.davem@davemloft.net> <20081013.003441.109866647.davem@davemloft.net> <20081013083214.GN2811@fc6222126.aspadmin.net> <20081013.025816.197282812.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081013.025816.197282812.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 02:58:16AM -0700, David Miller wrote:
> From: swivel@shells.gnugeneration.com
> Date: Mon, 13 Oct 2008 03:32:14 -0500
> 
> > I'm using the pseudo-blocking recv() behavior achieved with SO_RCVTIMEO.
> > Thus my app expects recv() to block until SO_RCVLOWAT is met or SO_RCVTIMEO
> > expired.
> 
> But if you poll() properly, you'll never call recv() unless the amount
> of bytes you want are there.
> 
> And since I fixed poll()'s handling of SO_RCVLOWAT it should mostly
> work.

The app already has a kludge in place to work around the current kernel
with broken poll() and recv() with regards to SO_RCVLOWAT.

It's less than ideal but 'mostly works', so I'm already at that point...
Doesn't really make sense to me to rewrite the kludge to depend on a
very modern kernel without even having it be able to use recv()
properly.

I just hope we can have recv() block with MSG_PEEK when SO_RCVLOWAT is
>1 in the near future.  My goal was next time I get around to doing a
dist-upgrade the new kernel would have both poll and recv fixed and I
could disable the kludge.

>From what I can see the recv() MSG_PEEK fix is trivial anyways, why not
fix it?

Thanks,
Vito Caputo
