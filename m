Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbYDDBnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbYDDBnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDDBno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:43:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50867 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYDDBnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:43:43 -0400
Date: Fri, 4 Apr 2008 10:47:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 5 of 6] hotplug-memory: add section_ops
Message-Id: <20080404104706.c97956ed.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1207270272.943.27.camel@nimitz.home.sr71.net>
References: <785fe0877fea0f488bc5.1207267545@localhost>
	<1207270272.943.27.camel@nimitz.home.sr71.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 17:51:12 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
> > Add a per-section "section_ops" structure,  allowing each section to have
> > specific functions for onlining and offlining pages within the section.
> > This is used by the Xen balloon driver to make sure that pages are not
> > onlined without some physical memory backing them.
> 
> This is kinda a lot of code and mucking around for what we actually get
> out of it, especially since you just condensed down all the actual
> online_page() instances.
> 
> I think it might just be nicer to have a global list of these handlers
> somewhere.  The Xen driver can just say "put me on the list of
> callbacks" and we'll call them at online_page().  I really don't think
> we need to be passing an ops structure around.
> 
> KAME, did you have some other ideas about this?
> 

At first. please don't call online_page() handler in add_memory() phase.
online_page() handler should be called in online_pages().

Passing handler to online_pages() is much easier and it's ok to me.


Thanks,
-Kame

