Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZCPRgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZCPRgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZCPRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:36:13 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59027 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZCPRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:36:12 -0400
Date: Mon, 16 Mar 2009 17:36:09 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
Message-ID: <20090316173609.GB10814@silver.sucs.org>
References: <49BD1EB7.6080109@fisher-privat.net> <20090315181315.GA4369@silver.sucs.org> <49BD7BEA.50307@fisher-privat.net> <20090315232614.GA27452@silver.sucs.org> <49BE011D.5080807@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BE011D.5080807@fisher-privat.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 08:34:53AM +0100, Alexey Fisher wrote:
> 
> If i read same somefile second time, normally will happen the same. It
> tries to read block 1 and  this is not it cache, so it will be cached
> and move block 6 out. ( |1|7|8|9|10| ) So it will complete replace
> entire cache.

Yup, that's my understanding (I'm no pro on this stuff though).
Different cache replacement algorithms will have different behviour
though (I believe Linux uses some variation on LRU -
http://linux-mm.org/AdvancedPageReplacement ).

> Or i can say, read somefile and only blocks 6-10 so i can use
> performance from cache.

Yup, you could do this but your code would have to have exactly this in
mind (e.g. skip the first 7 Mbytes THEN read 10 mbytes). There's nothing
automatic happening in this scenario from the cache's perspective -
you're just reading less so it (hopefully) doesn't become full and evict
what you want it to keep.

> Or OS need to get a list of blocks from somefile and list of cached
> blocks. And check if there is some of them cached. If they are, it
> should lock the cache, read 1-5 without caching it and read 6-10 from
> cache. After this unlock the cache. But this is not possible because
> this operation is to expensive.
> Is this what you mean?

Kinda. More like when you use memory mapped I/O (mmap) you can "lock"
pieces of the file into ram (and thus have those pieces always in
cache). See mlock -
http://opengroup.org/onlinepubs/007908799/xsh/mlock.html . There are
usually restrictions on just how much memory you can lock etc.

-- 
Sitsofe | http://sucs.org/~sits/
