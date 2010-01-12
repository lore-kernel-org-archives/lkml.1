Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453Ab0ALSIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0ALSIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 13:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135Ab0ALSIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 13:08:42 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:45408 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0ALSIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 13:08:42 -0500
Message-ID: <4B4CBA93.4090909@gmail.com>
Date: Tue, 12 Jan 2010 19:08:19 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: James Kosin <JKosin@intcomgrp.com>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: arm: Optimization for ethernet MAC handling at91_ether.c
References: <3DBBD805E3BA064A87F551C0E8BD3674028973F5@MAILSRV.intcomgrp.com> <4B4CA4E5.7030800@gmail.com> <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com>
In-Reply-To: <3DBBD805E3BA064A87F551C0E8BD36740289740E@MAILSRV.intcomgrp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 12 Jan 2010 19:08:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/01/2010 18:51, James Kosin a écrit :
> On 1/12/2010 11:40 AM, Eric Dumazet wrote:

>> If this happens once in a while, why do you want driver to retry the transmit ?
> 
> (a)  It would improve performance by allowing the ISR to handle the re-transmit in this case.
> (b)  It would help in the case of small glitches that may happen from external SDRAM without taxing the polling required to handle the re-transmit of the packet... ie: overhead required to re-queue and initiate a packet delivery... since the packet is already scheduled for delivery now.
> 

OK, but then this also adds an extra check for each tx completion.

I dont have this piece of hardware, but seeing it has a one skb tx queue (!),
I suppose TX performance is not very good anyway...


at91ether_interrupt() should probably handle tx completion before rx, to feed
next frame faster.

