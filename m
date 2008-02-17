Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYBQTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYBQTiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYBQTiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:38:12 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:35059 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYBQTiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:38:12 -0500
Message-ID: <47B88D18.8060907@tlinx.org>
Date: Sun, 17 Feb 2008 11:38:00 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Disk schedulers
References: <20080214162104.GA5347@ics.muni.cz>
In-Reply-To: <20080214162104.GA5347@ics.muni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> whom should I blame about disk schedulers?
>
> I have the following setup:
> 1Gb network
> 2GB RAM
> disk write speed about 20MB/s
>
> If I'm scping file (about 500MB) from the network (which is faster than the
> local disk), any process is totally unable to read anything from the local disk
> till the scp finishes. It is not caused by low free memory, while scping
> I have 500MB of free memory (not cached or buffered).
>
> I tried cfq and anticipatory scheduler, none is different.
> ----
>   
    You didn't say anything about #processors or speed, nor
did you say anything about your hard disk's raw-io ability.
You also didn't mention what kernel version or whether or not
you were using the new UID-group cpu scheduler in 2.6.24 (which likes
to default to 'on'; not a great choice for single-user, desktop-type
machines, if I understand its grouping policy). 

Are you sure neither end of the copy is cpu-bound on ssh/scp
encrypt/decrypt calculations? It might not just be inability
to read from disk, but low cpu availability.  Scp can be alot
more CPU intensive than you would expect...  Just something to
consider...

Linda

