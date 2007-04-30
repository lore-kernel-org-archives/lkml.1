Return-Path: <linux-kernel-owner+w=401wt.eu-S1946872AbXD3WoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946872AbXD3WoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946871AbXD3WoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:44:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59939 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946872AbXD3WoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:44:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <463670DB.9090003@s5r6.in-berlin.de>
Date: Tue, 01 May 2007 00:42:35 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>	 <20070430001311.84d0291f.akpm@linux-foundation.org>	 <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>	 <20070430100225.353e3030.akpm@linux-foundation.org>	 <20070430182135.0fae7b89@the-village.bc.nu> <a781481a0704301204i247a5123r1e6146c99b2e467e@mail.gmail.com>
In-Reply-To: <a781481a0704301204i247a5123r1e6146c99b2e467e@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 4/30/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> i2o/device.c should be GFP_KERNEL as far as I can tell. It was meant to
>> be that way and the callers appear to all be calling it in sleep capable
>> contexts.
>>
>> aic7xxx_old.c should probably be GFP_KERNEL as ->slave_alloc methods
>> appear to be able to sleep (although some drivers use GFP_ATOMIC here and
>> some GFP_KERNEL).
> 
> Yes, none of the above appear to be atomic contexts. GFP_KERNEL in
> that case would've been a bug. If they were atomic contexts, someone
> somewhere would've been seeing a lot of "BUG: sleeping function called
> from invalid context" messages and would've probably brought it to
> lkml's notice already ;-) So the GFP_ATOMIC seems to be redundant
> thing here in both cases.

Documentation/scsi/scsi_mid_low_api.txt agrees that ->slave_alloc is
allowed to sleep.
-- 
Stefan Richter
-=====-=-=== -=-= ----=
http://arcgraph.de/sr/
