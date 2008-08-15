Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYHONKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYHONKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYHONKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:10:23 -0400
Received: from mail12.ca.com ([141.202.248.38]:47391 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYHONKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:10:22 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Fri, 15 Aug 2008 09:10:21 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BF6@USILMS12.ca.com>
In-Reply-To: <1218796645.10800.242.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj+wuswb+NVA58JQGuWpL8AKZrjhwAFCZ4g
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><1218653864.3540.109.camel@localhost.localdomain><20080813143908.38796217@infradead.org><1218723133.3540.137.camel@localhost.localdomain><48A55574.9070508@aitel.hist.no> <1218796645.10800.242.camel@twins>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Peter Zijlstra" <peterz@infradead.org>,
       "Helge Hafting" <helge.hafting@aitel.hist.no>
Cc: <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <hch@infradead.org>, <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>,
       <alan@lxorguk.ukuu.org.uk>, "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 15 Aug 2008 13:10:21.0198 (UTC) FILETIME=[457892E0:01C8FED8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of Peter Zijlstra
> Sent: Friday, August 15, 2008 6:37 AM
> To: Helge Hafting
> Cc: linux-kernel@vger.kernel.org; malware-list@lists.printk.net;
hch@infradead.org;
> andi@firstfloor.org; viro@ZenIV.linux.org.uk;
alan@lxorguk.ukuu.org.uk; Arjan van
> de Ven
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> 
> On Fri, 2008-08-15 at 12:07 +0200, Helge Hafting wrote:
> > It seems to me that this "scan on file open" business is the
> > wrong way to do things - because it reduces performance.
> >
> > If you scan on file open, then your security sw is too late and
> > getting in the way.

The problem is that you have to account for the cases where the malware
made it onto the system even if you were trying to catch it ahead of
time.  For example:

- Administrator turns off or reduces AV protection for some reason for
some period of time.  It happens all the time.

- New infection makes it onto the machine before the signatures have
caught up with it.  This also happens.  There is an ongoing PR race
among AV vendors about who was faster on the draw to get out signatures
to detect some new malware.  The fact that this race exists reflects
that reality that there is some window during which new malware will
make it onto some number of machines before the scanners catch up.


> > It is better to scan in advance. Most machines has lots of idle
time.
> > Use that time to scan in advance, and mark the files as "clean".
> >
> > A "clean" file can be opened without further checking anytime -
giving
> > normal high performance.  A file that gets written to becomes
"dirty"
> > until checked again. Some mechanism for making a clean copy of a
> > clean file might help avoid excessive "dirtying".
> >
> > "Scan on open" might still be useful for cases when the system
> > haven't kept up with writing, but please don't aim to have
> > this be the _primary_ mode of scanning. A file server
> > where most of the stuff is pre-scanned will likely perform much
better
> > than  one scanning everything on open.

It isn't the primary mode.  It's the mode that catches things as they
arrive, and as they are about to be used.  Most sites will also employ
the applications' features for running regular scans of the whole system
on a scheduled basis, to catch anything that may have slipped through.


Jon Press

