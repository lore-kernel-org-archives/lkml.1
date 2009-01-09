Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZAIRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZAIRPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZAIRPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:15:11 -0500
Received: from ext-nj2ut-13.online-age.net ([64.14.54.246]:53217 "EHLO
	ext-nj2ut-13.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbZAIRPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:15:09 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 12:15:09 EST
Message-ID: <49678443.8040909@ge.com>
Date: Fri, 09 Jan 2009 18:07:15 +0100
From: Enrik Berkhan <Enrik.Berkhan@ge.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Reference counting of MMC host driver modules
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2009 17:07:19.0653 (UTC) FILETIME=[BB0DE150:01C9727C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've noticed recently that the MMC/SD block driver does not reference 
count the MMC/SD host driver module that it uses via the MMC/SD core 
layer. Thus, I can rmmod my host driver module while, for example, a 
partition on a SD card is mounted.

Assuming this does not happen intentionally, what would be the correct 
fix? Is a try_module_get(card->host->parent->driver->owner) in 
mmc_blk_alloc() in drivers/mmc/card/block.c the right thing to do? If 
so, I could provide a patch fixing the issue. If not, please give me 
advice how to do it better :) (May be I'm missing something that has to 
do with hotplugging, as the devices I'm using are non-removeable).

Or am I possibly doing something wrong in my host driver and this 
problem is not present for others at all?

Enrik
