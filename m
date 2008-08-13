Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYHMVP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYHMVP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYHMVPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:15:19 -0400
Received: from mail15.ca.com ([208.232.182.54]:12454 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYHMVPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:15:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] TALPA - a threat model?  well sorta.
Date: Wed, 13 Aug 2008 17:15:17 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BC1@USILMS12.ca.com>
In-Reply-To: <20080813192922.GI8232@mit.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] TALPA - a threat model?  well sorta.
Thread-Index: Acj9eu1YFoQpbdnxSSu/WzDqoApTKwADRvBA
References: <1218645375.3540.71.camel@localhost.localdomain><20080813103951.1e3e5827@infradead.org><20080813181549.GH8232@mit.edu><1218654168.3540.115.camel@localhost.localdomain> <20080813192922.GI8232@mit.edu>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Theodore Tso" <tytso@mit.edu>, "Eric Paris" <eparis@redhat.com>
Cc: <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>, <hch@infradead.org>,
       <andi@firstfloor.org>, <viro@ZenIV.linux.org.uk>,
       <alan@lxorguk.ukuu.org.uk>, "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 13 Aug 2008 21:15:18.0093 (UTC) FILETIME=[AFBEE7D0:01C8FD89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: malware-list-bounces@dmesg.printk.net [mailto:malware-list-
> bounces@dmesg.printk.net] On Behalf Of Theodore Tso
> Sent: Wednesday, August 13, 2008 3:29 PM
> To: Eric Paris
> Cc: peterz@infradead.org; linux-kernel@vger.kernel.org; malware-
> list@lists.printk.net; hch@infradead.org; andi@firstfloor.org;
> viro@ZenIV.linux.org.uk; alan@lxorguk.ukuu.org.uk; Arjan van de Ven
> Subject: Re: [malware-list] TALPA - a threat model? well sorta.
> 

 
> Also something else that is needed is support for multiple clients.
> (i.e., what happens if the user runs two virus checkers, or a virus
> checker plus a hierarchical storage manager driving a tape robot, or
> all of the above plus trackerd --- where some clients need to block
> open(2) access, and some do not need block open(2) --- and in the case
> of HSM, ordering becomes important; you want to retrieve the file from
> the tape robot first, *then* scan it using the virus checker.  :-)

The issue of multiple clients does need to be accounted for.  However, I
will mention that it is unusual (at least in my experience) to actually
run two AV products at the same time in "realtime" mode.  We strongly
recommend that anyone who installs our product should remove any other
AV product on the system -- for technical reasons, not financial --
since they've already paid for ours by the time they get to this point.
I am not aware of anyone objecting to that idea.


> I'm just arguing that there should be absolutely *no* support in the
> kernel for solving this particular problem, since the question of
> whether a file has been scanned with a particular version of the virus
> DB is purely a userspace problem.

Caching of previous results can be done in either user space or kernel
space.  We have seen it both ways.  Wherever it is done, I would say
that rather than record AV signature file version numbers, there should
be a mechanism for the application to invalidate or flush the cache
whenever a signature update is done.  There are other circumstances
where that would also be useful -- such as if the user changes a
scanning option in a way that increases the strictness of the scan.  In
other words, a file that was marked as clean based on one level of
strictness may not be clean under a stricter scan.  You wouldn't want
the cache to prevent it from being scanned under such circumstances.


Jon Press
