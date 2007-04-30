Return-Path: <linux-kernel-owner+w=401wt.eu-S1946388AbXD3Q4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946388AbXD3Q4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946389AbXD3Q4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:56:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42294 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946388AbXD3Q4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:56:19 -0400
Date: Mon, 30 Apr 2007 17:56:17 +0100 (BST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: Uwe Bugla <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
In-Reply-To: <4636058B.3070603@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
References: <20070429182209.267430@gmx.net> 
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org> 
 <20070429205925.129920@gmx.net>  <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
  <20070429230037.95120@gmx.net> <1177894713.3046.5.camel@pc06.localdom.local>
 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Helge and others,

On Mon, 30 Apr 2007, Helge Hafting wrote:

>> what the consequence is. To be truthful I would strategically prefare a 
>> vacuum at the price that the work isn't even done for months.
>> ONLY IF there is a personnel vacuum the necessity for others to volunteer 
>> will arise.
>> 
> A sufficiently bad maintainer will also do it.  If lots of submitters send
> their patches to andrew in order to get past a dysfunctional maintainer,
> then the subsystem effectively is unmaintained.

The point is that Uwe patch will generate regressions by breaking for 
Twinhan. His patch just removes compilation for dst and dst_ca on Kconfig, 
without taking care or driver internals. So, two initialization functions 
won't be called by symbol_request(). Although those two functions will be 
undefined, as the dvb will do the linkedition at module runtume (if 
DVB_ATTACH is selected), modprobe won't detect the lack of those functions.
At the end, cards with ST chips (DST and/or DST CA) will stop working, 
without even printing a warning.

I've tried to explain this to Uwe several times, but, at the end, he 
always start insulting me and/or other developers.

Cheers,
Mauro.
