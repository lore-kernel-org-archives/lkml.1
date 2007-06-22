Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbXFVSY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbXFVSY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXFVSYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:24:49 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:36329 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760249AbXFVSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:24:48 -0400
Date: Fri, 22 Jun 2007 11:25:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <ak@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] doc/oops-tracing: add Code: decode info
Message-Id: <20070622112503.f1fa10b0.randy.dunlap@oracle.com>
In-Reply-To: <200706221923.02736.ak@suse.de>
References: <20070621225108.bb69a93d.randy.dunlap@oracle.com>
	<200706221626.39969.ak@suse.de>
	<20070622094429.0910c7cb.randy.dunlap@oracle.com>
	<200706221923.02736.ak@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 19:23:02 +0200 Andi Kleen wrote:

> On Friday 22 June 2007 18:44, Randy Dunlap wrote:
> > On Fri, 22 Jun 2007 16:26:39 +0200 Andi Kleen wrote:
> > > On Friday 22 June 2007 07:51:08 Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > >
> > > > Add info that the Code: bytes line contains <xy> or (wxyz) in some
> > > > architecture oops reports and what that means.
> > > >
> > > > Add URL for a script by Andi Kleen that reads the Code: line from an
> > > > Oops report file and generates assembly code from the hex bytes.
> > > > (This script does not handle Code: lines that contain <xy> or (wxyz)
> > > > markings.)
> > >
> > > Should probably fix that and put it into scripts/ then
> >
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.
> 
> >
> > +*Code:*)
> > +	echo $i
> > +	echo -n "	.byte 0x" > $T.s
> > +	echo $i | sed -e 's/.*Code: //;s/ [<(]/ /;s/[>)] / /;s/ /,0x/g' >> $T.s
> > +	as -o $T.o $T.s
> > +	objdump -S $T.o
> 
> This still has a couple of problems:
> 
> - The <> information is lost. It would be better to split and run 
> objdump three times and insert a marker

Why 3 times?  Why not just (1) everything before marker and
(2) everything at and after marker?

> - It won't handle multiline Code:s which i386 likes to generate now I think

I don't see the code in arch/i386/kernel/traps.c generating multiline
Code:s, just very long single lines.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
