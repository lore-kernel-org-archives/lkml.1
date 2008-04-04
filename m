Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYDDBJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYDDBJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYDDBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:09:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54135 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYDDBJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:09:36 -0400
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to
	separate zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <5a397e7f3c1aeb7648b9.1207267541@localhost>
References: <5a397e7f3c1aeb7648b9.1207267541@localhost>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 18:09:31 -0700
Message-Id: <1207271371.943.43.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> 
> +int prepare_online_pages(unsigned long pfn, unsigned long nr_pages)
> +{
> +       int ret = notify_going_online(pfn, nr_pages);
> +       if (ret)
> +               return ret;
> +
> +       grow_zone_span(pfn, pfn+nr_pages);
>         return 0;
> +}

OK, after seeing this used in the Xen driver, I'm even less a fan of the
name.  Mostly because it doesn't actually prepare *pages* to be onlined.
It prepares the zones/pgdats and notifies that pages might soon be
online.  Can you think of any better names?

grow_and_notify...??

It's also a bit funky because you're calling the online notifiers, but
you're not actually onlining the pages, yet.  Does that have any
repercussions?

-- Dave

