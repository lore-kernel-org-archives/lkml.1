Return-Path: <linux-kernel-owner+w=401wt.eu-S936852AbXHLREh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936852AbXHLREh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936573AbXHLRDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:03:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55040 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936559AbXHLRDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:03:45 -0400
Date: Sun, 12 Aug 2007 19:03:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: david@lang.hm
cc: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,
 anyways? [compare with e.g. NBD + MD raid])
In-Reply-To: <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm>
Message-ID: <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr>
References: <200708121335.17267.a1426z@gawab.com>
 <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12 2007 09:39, david@lang.hm wrote:
>
> now, I am not an expert on either option, but three are a couple things that I
> would question about the DRDB+MD option
>
> 1. when the remote machine is down, how does MD deal with it for reads and
> writes?

I suppose it kicks the drive and you'd have to re-add it by hand unless done by
a cronjob.

> 2. MD over local drive will alternate reads between mirrors (or so I've been
> told), doing so over the network is wrong.

Certainly. In which case you set "write_mostly" (or even write_only, not sure
of its name) on the raid component that is nbd.

> 3. when writing, will MD wait for the network I/O to get the data saved on the
> backup before returning from the syscall? or can it sync the data out lazily

Can't answer this one - ask Neil :)




	Jan
-- 
