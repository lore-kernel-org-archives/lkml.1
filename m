Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbXDIUQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbXDIUQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXDIUQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:16:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56139 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989AbXDIUQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:16:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
Date: Mon, 9 Apr 2007 22:20:09 +0200
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
References: <460B6E4B.3060004@gmail.com> <200704031250.07307.rjw@sisk.pl> <461A9D12.1060106@gmail.com>
In-Reply-To: <461A9D12.1060106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092220.10039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 9 April 2007 22:07, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > Thanks for testing.
> [...]
> > --- linux-2.6.21-rc5.orig/kernel/power/swsusp.c
> > +++ linux-2.6.21-rc5/kernel/power/swsusp.c
> > @@ -229,13 +229,13 @@ int swsusp_shrink_memory(void)
> >  		size += highmem_size;
> >  		for_each_zone (zone)
> >  			if (populated_zone(zone)) {
> > +				tmp += snapshot_additional_pages(zone);
> >  				if (is_highmem(zone)) {
> >  					highmem_size -=
> >  					zone_page_state(zone, NR_FREE_PAGES);
> >  				} else {
> >  					tmp -= zone_page_state(zone, NR_FREE_PAGES);
> >  					tmp += zone->lowmem_reserve[ZONE_NORMAL];
> > -					tmp += snapshot_additional_pages(zone);
> 
> I have bad news for you :(. I thought I had unpatched kernel, but it happens
> in -rc6 too.

I guess you mean you're still seeing the 'not enough memory to suspend'
problem?
 
> Next, when this occurs, kernel CPU1 is not brought up and next suspend hangs
> on "Suspending consoles".

Hm, there probably is a bug in an error path.  Do you use the built in swsusp
or s2disk?

Rafael
