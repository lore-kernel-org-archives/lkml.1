Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZFVMdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZFVMdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFVMdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:33:43 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:29541 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750790AbZFVMdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:33:42 -0400
X-IronPort-AV: E=Sophos;i="4.42,268,1243807200"; 
   d="scan'208";a="31708306"
Message-ID: <4A3F7A49.6070805@inria.fr>
Date: Mon, 22 Jun 2009 14:34:17 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Stefan Lankes <lankes@lfbs.rwth-aachen.de>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>	 <87zldjn597.fsf@basil.nowhere.org>	 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>	 <20090612103251.GJ25568@one.firstfloor.org>	 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>	 <1245119977.6724.40.camel@lts-notebook>	 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>	 <1245164395.15138.40.camel@lts-notebook>	 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de> <1245299856.6431.30.camel@lts-notebook>
In-Reply-To: <1245299856.6431.30.camel@lts-notebook>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn wrote:
> On Wed, 2009-06-17 at 09:45 +0200, Stefan Lankes wrote:
>   
>>> I've placed the last rebased version in :
>>>
>>> http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.28-rc4-mmotm-
>>> 081110/
>>>
>>>       
>> OK! I will try to reconstruct the problem.
>>     
>
> Stefan:
>
> Today I rebased the migrate on fault patches to 2.6.30-mmotm-090612...
> [along with my shared policy series atop which they sit in my tree].
> Patches reside in:
>
> http://free.linux.hp.com/~lts/Patches/PageMigration/2.6.30-mmotm-090612-1220/
>
>   

I gave this patchset a try and indeed it seems to work fine, thanks a
lot. But the migration performance isn't very good. I am seeing about
540MB/s when doing mbind+touch_all_pages on large buffers on a
quad-barcelona machines. move_pages gets 640MB/s there. And my own
next-touch implementation were near 800MB/s in the past.

I wonder if there is a more general migration performance degradation in
latest Linus git. move_pages performance was supposed to increase by 15%
(more than 700MB/s) thanks to commit dfa33d45 but I don't seem to see
the improvement with git or mmotm. Also migrate_pages seems to have
decreased but it might be older than 2.6.30. I need to find some time to
git bisect all this, otherwise it's hard to compare the performance of
your migrate-on-fault with other older implementations :)

When do you plan to actually submit all your patches for inclusion?

thanks,
Brice

