Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207Ab0AMSJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0AMSJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998Ab0AMSJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:09:09 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:58138 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0AMSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:09:08 -0500
Message-ID: <4B4E0C2C.1000101@gmail.com>
Date: Wed, 13 Jan 2010 19:08:44 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Kosin <JKosin@intcomgrp.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: at91_ether.c - Allow transmitter interrupt to
 be handled first in ISR
References: <3DBBD805E3BA064A87F551C0E8BD367402897491@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD367402897491@MAILSRV.intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 13 Jan 2010 19:08:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2010 18:46, James Kosin a écrit :
> Ok,
> 
> This next patch is optional....
> 
> The idea is TUND should only happen on occasions when the PHY is unable
> to receive the transmitter data in a timely fashion to successfully send
> the data in a single burst.  This is not a hard error; so, why do we
> treat it as such.
> 
> This patch allows the transmitter to resend the failed skb inside the
> ISR without having to deal with the overhead of freeing the skb then
> having the main task re-allocate a new skb for the failed packet.

Are we sure chip doesnt report TUND forever in some situations ?
Should'nt we have a retry limit for each skb ?

> 
> James Kosin
> 
--- C:/Documents and Settings/jkosin/My Documents/junk/kernel/Copy of linux-2.6.31.5/drivers/net/arm/at91_ether.c	Wed Jan 13 12:26:13 2010
+++ C:/Documents and Settings/jkosin/My Documents/junk/kernel/linux-2.6.31.5/drivers/net/arm/at91_ether.c	Wed Jan 13 12:38:55 2010

Oh well :)

Please read Documentation/SubmittingPatches


1) Should be in "diff -u" form
9) Your patch should be based on latest kernel (preferrably on David net-next-2.6 git tree)

12) Should be Signed-off-by


You said in a previous mail the chip was capable of queueing two frames,
it would be nice to exploit this in driver, since at91 has only one frame
in transmit queue.
