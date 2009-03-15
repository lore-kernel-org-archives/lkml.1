Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbZCOX01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbZCOX01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZCOX0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:26:18 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:41170 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZCOX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:26:18 -0400
Date: Sun, 15 Mar 2009 23:26:14 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
Message-ID: <20090315232614.GA27452@silver.sucs.org>
References: <49BD1EB7.6080109@fisher-privat.net> <20090315181315.GA4369@silver.sucs.org> <49BD7BEA.50307@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BD7BEA.50307@fisher-privat.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 11:06:34PM +0100, Alexey Fisher wrote:
> 
> It is not what i mean. I know how to clear cache but exactly i do not 
> won't it. I will use cache and it's working perfectly with small files. 

I meant for timings on the small files otherwise how do you know which
exactly pages were floating around the cache?

> But there is a problem with big files. For example i have 4GB RAM, if i 
> read 4,6GB file the cache is useless. The question is; are there any way 
> to workaround it, except more RAM?

I suspect what is happening is that you are cycling the cache. Because
you can't hold everything and you are reading the file sequentially you
will successfully have cleared the cache of the start of the file by the
time you start again (so first bit gets evicted by the time last bit is
read etc). If you use dd bs=1000M count=1 I think you will find that the
kernel CAN cache pieces of files but as pointed out elsewhere, without
knowing the future what do you decide to keep when your cache is full?

At a guess you either you need to provide a hint (e.g. bybassing the
cache for some of the file so it doesn't become full or locking specific
pages into RAM) or create a bigger cache somehow (e.g. by buying more
RAM).

-- 
Sitsofe | http://sucs.org/~sits/
