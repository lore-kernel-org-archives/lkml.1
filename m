Return-Path: <linux-kernel-owner+w=401wt.eu-S1761348AbYHUXZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761348AbYHUXZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYHUXZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:25:12 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:59107 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYHUXZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:25:11 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: writable packet CD mounting in 2.6.26.x?
References: <87ej52vtxq.fsf@hades.wkstn.nix>
	<20080808031437.GA14249@martell.zuzino.mipt.ru>
	<20080808053735.GA5274@martell.zuzino.mipt.ru>
From: Nix <nix@esperi.org.uk>
Emacs: an inspiring example of form following function... to Hell.
Date: Fri, 22 Aug 2008 00:25:02 +0100
In-Reply-To: <20080808053735.GA5274@martell.zuzino.mipt.ru> (Alexey Dobriyan's message of "Fri, 8 Aug 2008 09:37:35 +0400")
Message-ID: <874p5eq7ch.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-INFN-TO-Metrics: hades 1233; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Back now, sorry for the delay, but I didn't even have mobile phone access
 in my tent, let alone an Internet connection. I had lots of running water,
 though, lots and lots and lots: I'm not sure it stopped raining for more
 than ten minutes in that whole week.]

On 8 Aug 2008, Alexey Dobriyan uttered the following:
> On Fri, Aug 08, 2008 at 07:14:37AM +0400, Alexey Dobriyan wrote:
>> > Anyone got any ideas? There are no suspicious-looking changes in
>> > pktcdvd.c itself, so maybe this lies deeper in the block layer. Or
>> > perhaps I'm mounting it wrong in some obscure way.
>
> Ho-hum, I get ->mmc3_profile = 9 here in both .25 anf .26 kernel, so I
> can't meaningfully debug it here. :-(
>
> Does it -EROFS because of pkt_writable_disc()? If yes, apply this patch
> too.

Too? Was there another patch?

I see

pkt_probe_settings: 00 00 00 ac 00 00 00 00 00 00 00 00
pkt_probe_settings: pd = edd80ee0, ->mmc3_profile = 0
pkt_writable_disc: pd = edd80ee0, ->mmc3_profile = 0

Thus we get 0 back from pkt_writable_disc(). (This drive is a Yamaha
CRW3200E, at least five years old, but it's a CD-RW so should definitely
support MMC3, I'd have thought.)

That probe result looks really odd. Maybe something's wrong with sg?

(This is an ATAPI device, and I'm using the old IDE layer, not
libata. Maybe I should switch and see if libata works better...)
