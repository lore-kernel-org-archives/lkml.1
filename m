Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbXFDB3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbXFDB3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXFDB3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:29:36 -0400
Received: from keil-draco.com ([216.193.185.50]:50321 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXFDB3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:29:35 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Nix <nix@esperi.org.uk>
Subject: Re: Patch related with Fork Bombing Atack
Date: Sun, 3 Jun 2007 21:29:28 -0400
User-Agent: KMail/1.9.6
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Anand Jahagirdar <anandjigar@gmail.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> <20070601073020.GL32105@kernel.dk> <87odjw8wxq.fsf@hades.wkstn.nix>
In-Reply-To: <87odjw8wxq.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706032129.29088.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 June 2007 19:01:21 Nix wrote:
> On 1 Jun 2007, Jens Axboe told this:
> > I think Anand is assuming that because syslog may coalesce identical
> > messages into "repeated foo times" in the messages file, that it's not a
> > dos. That is of course wrong.
>
> Not all syslog daemons do that, anyway. (syslog-ng doesn't, for one.)

That syslog-ng doesn't coalesce repeated messages into a single line doesn't 
make a difference. The printk_ratelimit stuff is supposed to make it very 
hard to DOS a system by flooding syslog, but that doesn't mean its 
impossible. 

The point of this discussion was that having a part of the kernel log a 
message about a fork-bomb was a very large whole that could be used to DOS a 
system by flooding the syslog. (In fact, IIRC, the printk_ratelimit (and 
somebody, please correct me if I'm wrong) stuff uses a ring buffer and 
seriously spamming syslog, like the patch that spawned this thread would have 
done, could cause you to lose potentially important messages)

DRH
