Return-Path: <linux-kernel-owner+w=401wt.eu-S933995AbYF3WUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbYF3WUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762946AbYF3WUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:20:18 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:36689 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763187AbYF3WUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:20:17 -0400
Message-ID: <48695C20.6050704@fastmq.com>
Date: Tue, 01 Jul 2008 00:20:16 +0200
From: Martin Sustrik <sustrik@fastmq.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: Martin Lucina <mato@kotelna.sk>, linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
References: <20080628121131.GA14181@nodbug.moloch.sk> <48663873.5010200@gmail.com> <486921AD.8060308@fastmq.com> <48692DC0.6060904@gmail.com>
In-Reply-To: <48692DC0.6060904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

>> Fair enough. That exaplains the behaviour. Would AIO help here? If we 
>> are able to enqueue next write before the first one is finished, it 
>> can start writing it immediately without waiting for a revolution.
> 
> If you could get them queued at the disk level, things that would need 
> to be watched were if the disk can queue things up (and all 
> controllers/drivers support it), and how many things the disk can queue 
> up, and how large each of those things can be, if they aren't queued at 
> the disk, there is the chance that the machine cannot get the data to 
> the disk faster enough for that next sector.

We'll try with AIO and we'll see what the impact would be.

> Depending on your application you could always get a small fast solid 
> state device (no seek or RPM issues), and use it to keep a journal that 
> could be replayed on an unexpected crash...and then just use various 
> syncs to force things to disk at various points.

Yes, that's one thing we want to do. However, we cannot assume that 
every user will have SSD, thus we should try to get the best latencies 
possible even on standard HD.

Martin
