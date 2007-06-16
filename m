Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXFPHvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXFPHvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 03:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXFPHvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 03:51:35 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:40554
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbXFPHve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 03:51:34 -0400
Date: Sat, 16 Jun 2007 00:48:57 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Neil Brown <neilb@suse.de>
cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <18035.23867.576212.859440@notabene.brown>
Message-ID: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Neil Brown wrote:

> It would be possible to have a 'this is not initialised' flag on the
> array, and if that is not set, always do a reconstruct-write rather
> than a read-modify-write.  But the first time you have an unclean
> shutdown you are going to resync all the parity anyway (unless you
> have a bitmap....) so you may as well resync at the start.
>
> And why is it such a big deal anyway?  The initial resync doesn't stop
> you from using the array.  I guess if you wanted to put an array into
> production instantly and couldn't afford any slowdown due to resync,
> then you might want to skip the initial resync.... but is that really
> likely?

in my case it takes 2+ days to resync the array before I can do any 
performance testing with it. for some reason it's only doing the rebuild 
at ~5M/sec (even though I've increased the min and max rebuild speeds and 
a dd to the array seems to be ~44M/sec, even during the rebuild)

I want to test several configurations, from a 45 disk raid6 to a 45 disk 
raid0. at 2-3 days per test (or longer, depending on the tests) this 
becomes a very slow process.

also, when a rebuild is slow enough (and has enough of a performance 
impact) it's not uncommon to want to operate in degraded mode just long 
enought oget to a maintinance window and then recreate the array and 
reload from backup.

David Lang
