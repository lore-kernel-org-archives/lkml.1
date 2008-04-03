Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYDCHID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYDCHID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 03:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbYDCHHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 03:07:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44112 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbYDCHHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 03:07:52 -0400
Date: Thu, 3 Apr 2008 16:03:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
Message-Id: <20080403160316.c341bc0e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F404F1.30103@goop.org>
References: <47ED8685.9040409@goop.org>
	<1206751622.27091.20.camel@nimitz.home.sr71.net>
	<47EDA4B9.6030801@goop.org>
	<1206806774.31896.27.camel@nimitz.home.sr71.net>
	<47EED683.5030200@goop.org>
	<1206981741.31896.51.camel@nimitz.home.sr71.net>
	<47F1282E.3020503@goop.org>
	<1207161962.23710.23.camel@nimitz.home.sr71.net>
	<47F3D5D9.1010301@goop.org>
	<1207162792.23710.28.camel@nimitz.home.sr71.net>
	<47F3F4A0.9010009@goop.org>
	<1207171050.23710.48.camel@nimitz.home.sr71.net>
	<47F3FC2E.7090806@goop.org>
	<1207172610.23710.55.camel@nimitz.home.sr71.net>
	<47F404F1.30103@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Apr 2008 15:13:05 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Yeah, but I'm just talking about hotplugged memory.  When we add it, we
> > don't have to map the added pages (since they're highmem) and don't have
> > to touch their contents and zero them out, either.  Then, the balloon
> > driver can notice that the memory is too large, and start to balloon it
> > down.
> >   
> 
> I didn't think x86-64 had a notion of highmem.
> 
> How do you prevent the pages from being used before they're ballooned out?
> 

As I mentioned before, you can do that by plug online_page().

Now, online_page() is per-architecture. So, it's not so bad to make this
online_page() to be just a callback.
=
int online_page(struct page *page)
{
	if (online_page_callback)
		return (*online_page_callback)(struct page *page);
	retrun arch_default_online_page(page);
}
=
maybe not so dirty look. 

your ballon driver can overwrite this callback pointer.

Thanks,
-Kame

