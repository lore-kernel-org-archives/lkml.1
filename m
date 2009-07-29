Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZG2LVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZG2LVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 07:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZG2LVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 07:21:32 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:42635 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZG2LVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 07:21:31 -0400
Message-ID: <4A70309A.3030304@de.ibm.com>
Date: Wed, 29 Jul 2009 13:20:58 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reply-To: gerald.schaefer@de.ibm.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
Subject: Re: [PATCH] hibernate / memory hotplug: always use for_each_populated_zone()
References: <1248103551.23961.0.camel@localhost.localdomain> <20090721071508.GB12734@osiris.boeblingen.de.ibm.com> <20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com> <200907211611.09525.rjw@sisk.pl>
In-Reply-To: <200907211611.09525.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
>>> So it looks like checking for pfn_valid() and afterwards checking
>>> for PG_Reserved (?) might give what one would expect.
>> I think so, too. If memory is offline, PG_reserved is always set.
>>
>> In general, it's expected that "page is contiguous in MAX_ORDER range"
>> and no memory holes in MAX_ORDER. In most case, PG_reserved is checked
>> for skipping not-existing memory.
> 
> PG_reserved is also set for kernel text, at least on some architectures, and
> for some other areas that we want to save.

How about checking for PG_reserved && ZONE_MOVABLE? I think we don't
have any special cases for PG_reserved inside ZONE_MOVABLE, but I'm not
sure if this is true for all architectures and NUMA systems.

If this would work, it could be a simple way to determine which hotplug
memory should be saved.

--
Regards,
Gerald
