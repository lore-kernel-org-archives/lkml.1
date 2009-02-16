Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZBPCUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZBPCUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 21:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbZBPCUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 21:20:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:41780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbZBPCUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 21:20:22 -0500
Date: Sun, 15 Feb 2009 18:20:12 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090215182012.3bc6b292@infradead.org>
In-Reply-To: <1234750360.26036.115.camel@pasglop>
References: <200902160010.16955.rjw@sisk.pl>
	<20090215164456.34aef7e8@infradead.org>
	<1234750360.26036.115.camel@pasglop>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 13:12:40 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Sun, 2009-02-15 at 16:44 -0800, Arjan van de Ven wrote:
> > On Mon, 16 Feb 2009 00:10:15 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Hi,
> > > 
> > > The recent descussion about the Android PM patches sent by Arve
> > > shows that there is a need to introduce a mechanism allowing us
> > > to: (1) automatically put the system as a whole into a sleep
> > > state (eg. suspend to RAM) when it is found to be "idle", where
> > > the meaning of "idle" has to be defined too,
> > > (2) put given subset of devices into low power states whenever
> > > they are not used, without putting the entire system into a sleep
> > > state.
> > 
> > 
> > For (2), for me the answer is very obvious:
> 
>  .../...
> 
> I agree with pretty much everything Arjan wrote here.
> 
> > Userland should never ever control the state of a device like this
> > directly. It should do so by a) closing the device and b) setting
> > latency / functional requirements
> 
> With the possible exception of things like wifi/bt killswitch 

this is a functional switch; but yeah it is a little bit of an odd-one
out. rfkill is also not REALLY for power, it's more for FAA stuff.

>or
> network or similar where the driver cannot shut the device down
> without losing the ability to detect activity (ie, switch your PHY
> off is nice but you lose the ability to monitor the link for example).

what this needs is a separation between "interface down, all off" and
"interface down enough so that link detection works".
Some NICs can go all the way down and still do link detection, others
cannot. This is obviously something the driver will know, nothing else
in the system should know.

> 
> Cheers,
> Ben.
> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
