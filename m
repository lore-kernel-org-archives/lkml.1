Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZCLMTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZCLMTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZCLMTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:19:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:53000 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZCLMTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:19:21 -0400
X-IronPort-AV: E=Sophos;i="4.38,350,1233550800"; 
   d="scan'208";a="84252502"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] NOMMU: Pages allocated to a ramfs inode's pagecache may  get wrongly discarded
Date: Thu, 12 Mar 2009 08:19:08 -0400
User-Agent: KMail/1.9.5
CC: "Minchan Kim" <minchan.kim@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, dhowells@redhat.com,
       torvalds@linux-foundation.org, peterz@infradead.org,
       Enrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Johannes Weiner" <hannes@cmpxchg.org>,
       "Rik van Riel" <riel@surriel.com>,
       "Lee Schermerhorn" <lee.schermerhorn@hp.com>
References: <20090311170207.1795cad9.akpm@linux-foundation.org> <28c262360903111735s2b0c43a3pd48fcf8d55416ae3@mail.gmail.com> <20090312100049.43A3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090312100049.43A3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200903120819.08724.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 12 Mar 2009 12:19:09.0582 (UTC) FILETIME=[BEFAEAE0:01C9A30C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11 Mar 2009 21:04, KOSAKI Motohiro pondered:
> Hi
> 
> > >> Page reclaim shouldn't be even attempting to reclaim or write back
> > >> ramfs pagecache pages - reclaim can't possibly do anything with 
> > >> these pages!
> > >>
> > >> Arguably those pages shouldn't be on the LRU at all, but we haven't
> > >> done that yet.
> > >>
> > >> Now, my problem is that I can't 100% be sure that we _ever_
> > >> implemented this properly. ?I _think_ we did, in which case 
> > >> we later broke it. ?If we've always been (stupidly) trying 
> > >> to pageout these pages then OK, I guess your patch is a 
> > >> suitable 2.6.29 stopgap. 
> > >
> > > OK, I can't find any code anywhere in which we excluded ramfs pages
> > > from consideration by page reclaim. ?How dumb.
> > 
> > The ramfs  considers it in just CONFIG_UNEVICTABLE_LRU case
> > It that case, ramfs_get_inode calls mapping_set_unevictable.
> > So,  page reclaim can exclude ramfs pages by page_evictable.
> > It's problem .
> 
> Currently, CONFIG_UNEVICTABLE_LRU can't use on nommu machine
> because nobody of vmscan folk havbe nommu machine.
> 
> Yes, it is very stupid reason. _very_ welcome to tester! :)

As always - if you (or any kernel developer) would like a noMMU machine to 
test on - please send me a private email.
