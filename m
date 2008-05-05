Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbYEESYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbYEESYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYEESXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:23:18 -0400
Received: from s15216962.onlinehome-server.info ([217.160.22.205]:33745 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755824AbYEESXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:23:17 -0400
Date: Mon, 5 May 2008 20:23:09 +0200
From: Enrico Weigelt <weigelt@metux.de>
To: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505182308.GG32019@nibiru.local>
Reply-To: weigelt@metux.de
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local> <20080505131307.GM5882@ZenIV.linux.org.uk> <20080505134315.GF32019@nibiru.local> <20080505153501.GN5882@ZenIV.linux.org.uk> <E1Jt3nB-0006ZP-6S@pomaz-ex.szeredi.hu> <20080505171425.GO5882@ZenIV.linux.org.uk> <E1Jt4Ye-0006hz-9i@pomaz-ex.szeredi.hu> <20080505174048.GP5882@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505174048.GP5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.1i
X-Terror: bin laden, kill bush, Briefbombe, Massenvernichtung, KZ, 
X-Nazi: Weisse Rasse, Hitlers Wiederauferstehung, 42, 
X-Antichrist: weg mit schaeuble, ausrotten, heiliger krieg, al quaida, 
X-Killer: 23, endloesung, Weltuntergang, 
X-Doof: wer das liest ist doof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Al Viro <viro@ZenIV.linux.org.uk> wrote:

> > Symlinks are easy: filesystem just needs to *stop* the resolution the
> > moment it finds one.
> 
> That assumes you see types of objects as you do multi-step walk...

I've just read the spec for walk again:

Assuming the server doesn't resolve symlinks itself, the walk
will fail right at the symlink. So we can have a deeper look
here and try stat()'ing (adds one more request). If the fail 
point *is* an symlink, we need to properly handle it.

Would it be very complicated to give the link target back to
VFS and let the lookup start again (w/ new name) ?

> No - you need inodes as well (i.e. as the absolute least you want
> mode and ownership).  Which is to say, you need to issue stat on
> each component in such situation anyway.  Not a win...

Naive question: is it really *necessary* to have all the 
intermediate dirs in dcache ?


cu
-- 
---------------------------------------------------------------------
 Enrico Weigelt    ==   metux IT service - http://www.metux.de/
---------------------------------------------------------------------
 Please visit the OpenSource QM Taskforce:
 	http://wiki.metux.de/public/OpenSource_QM_Taskforce
 Patches / Fixes for a lot dozens of packages in dozens of versions:
	http://patches.metux.de/
---------------------------------------------------------------------
