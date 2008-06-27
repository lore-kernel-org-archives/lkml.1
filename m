Return-Path: <linux-kernel-owner+w=401wt.eu-S1765193AbYF0XOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765193AbYF0XOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 19:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765408AbYF0XDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 19:03:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765317AbYF0XDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 19:03:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <david.woodhouse@intel.com>
Subject: Re: linux-next: Tree for June 26
Date: Sat, 28 Jun 2008 01:04:16 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au> <200806270138.53895.rjw@sisk.pl> <1214563913.10393.180.camel@pmac.infradead.org>
In-Reply-To: <1214563913.10393.180.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806280104.17527.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 of June 2008, David Woodhouse wrote:
> On Fri, 2008-06-27 at 01:38 +0200, Rafael J. Wysocki wrote:
> > commit 423c982fffb1cd95c8cdd654ce5ab59351ba41f5
> > Author: Jaswinder Singh <jaswinder@infradead.org>
> > Date:   Wed Jun 18 19:58:33 2008 +0530
> > 
> >     firmware: convert tg3 driver to request_firmware()
> > 
> > breaks my nx6325.
> > 
> > Apparently, with this patch applied the tg3 has a NULL pointer dereference
> > somewhere, but I can only see the first line of the oops, afterwards the box
> > hangs solid.
> 
> That's a 5705, isn't it? So using the 'tso5' firmware?
> 
> Is that firmware available (did you either build it into your kernel, or
> run 'make INSTALL_FW_PATH=/lib/firmware firmware_install')? 

I built it into the kernel.

> Not that it matters; I suspect the driver isn't trying to load it at
> all. Can you test this patch, please?

Unfortunately, it doesn't help.  The driver either oopses or just doesn't work
(I don't know what exactly causes it to oops, although that only happens during
boot).

However, Ingo wrote that

" the firmware image, if i compare the before and after tg3FwText 
hex dump is blatantly different. Is this some different format, or did 
the "convert to request_firmware()" commit also embed an undocumented 
version jump in the binary blob that is loaded to your card? "

May this be the source of the problem?

Rafael
