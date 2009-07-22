Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZGVAkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZGVAkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 20:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbZGVAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 20:40:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47704 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbZGVAki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 20:40:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 22 Jul 2009 09:38:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org
Subject: Re: [PATCH] hibernate / memory hotplug: always use
 for_each_populated_zone()
Message-Id: <20090722093847.61f0e4ee.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090722092535.5eac1ff6.kamezawa.hiroyu@jp.fujitsu.com>
References: <1248103551.23961.0.camel@localhost.localdomain>
	<20090721071508.GB12734@osiris.boeblingen.de.ibm.com>
	<20090721163846.2a8001c1.kamezawa.hiroyu@jp.fujitsu.com>
	<200907211611.09525.rjw@sisk.pl>
	<20090722092535.5eac1ff6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 09:25:35 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> See ia64's ia64_pfn_valid(). It uses get_user() very effectively.
> (I think this cost cost is small in any arch...)
> 
>  523 ia64_pfn_valid (unsigned long pfn)
>  524 {
>  525         char byte;
>  526         struct page *pg = pfn_to_page(pfn);
>  527 
>  528         return     (__get_user(byte, (char __user *) pg) == 0)
>  529                 && ((((u64)pg & PAGE_MASK) == (((u64)(pg + 1) - 1) & PAGE_MASK))
>  530                         || (__get_user(byte, (char __user *) (pg + 1) - 1) == 0));
>  531 }
> 
Just an explanation. This code is for checking "there is memmap or not" for 
CONFIG_VIRTUAL_MEMMAP+CONFIG_DISCONTIGMEM, which allocates memmap in virtually
contiguous area. Because ia64 tends to have very sparse memory map,
memmap cannot be allocated in continuous area and memmap has holes.

This code checkes first byte and last byte of "struct page" is valid.

Thanks,
-Kame

