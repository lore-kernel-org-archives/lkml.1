Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXEaBmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXEaBmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbXEaBl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:41:57 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:18567 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXEaBl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:41:56 -0400
Date: Wed, 30 May 2007 18:39:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3 -mm] slub: use lib/hexdump
Message-Id: <20070530183959.29085b46.randy.dunlap@oracle.com>
In-Reply-To: <465DF566.7000000@oracle.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	<20070524073131.GA17501@elte.hu>
	<Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	<20070524142908.f39f42ea.akpm@linux-foundation.org>
	<20070524145517.1f32cd94.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
	<20070530143451.f4a844bc.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705301443020.3358@schroedinger.engr.sgi.com>
	<465DF135.80202@oracle.com>
	<Pine.LNX.4.64.0705301451140.3709@schroedinger.engr.sgi.c!  om>
	<465DF2A2.2070801@oracle.com>
	<Pine.LNX.4.64.0705301501470.7502@schroedinger.engr.sgi.com>
	<465DF566.7000000@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 15:06:30 -0700 Randy Dunlap wrote:

> Christoph Lameter wrote:
> > I'd prefer something like this:
> > 
> > Use hexdump in slub.
> 
> Sure, that's fine.

Just needs to #include <linux/kernel.h>


> > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > 
> > Index: slub/mm/slub.c
> > ===================================================================
> > --- slub.orig/mm/slub.c	2007-05-30 14:56:14.000000000 -0700
> > +++ slub/mm/slub.c	2007-05-30 15:01:33.000000000 -0700
> > @@ -339,34 +339,10 @@ static char *slub_debug_slabs;
> >   */
> >  static void print_section(char *text, u8 *addr, unsigned int length)
> >  {
> > -	int i, offset;
> > -	int newline = 1;
> > -	char ascii[17];
> > -
> > -	ascii[16] = 0;
> > -
> > -	for (i = 0; i < length; i++) {
> > -		if (newline) {
> > -			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
> > -			newline = 0;
> > -		}
> > -		printk(" %02x", addr[i]);
> > -		offset = i % 16;
> > -		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
> > -		if (offset == 15) {
> > -			printk(" %s\n",ascii);
> > -			newline = 1;
> > -		}
> > -	}
> > -	if (!newline) {
> > -		i %= 16;
> > -		while (i < 16) {
> > -			printk("   ");
> > -			ascii[i] = ' ';
> > -			i++;
> > -		}
> > -		printk(" %s\n", ascii);
> > -	}
> > +	char buf[10];
> > +
> > +	sprintf(buf, "%8s:", text);
> > +	print_hex_dump(KERN_ERR, buf, DUMP_PREFIX_ADDRESS, 16, 1, addr, length, 1);
> >  }
> >  
> >  static struct track *get_track(struct kmem_cache *s, void *object,
> > 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
