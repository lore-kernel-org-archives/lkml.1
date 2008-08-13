Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbYHMKq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbYHMKq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYHMKqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:46:48 -0400
Received: from mail12.ca.com ([141.202.248.38]:12106 "EHLO mail12.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbYHMKqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:46:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Wed, 13 Aug 2008 06:46:46 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304AE4BA4@USILMS12.ca.com>
In-Reply-To: <20080813102802.GC27074@atrey.karlin.mff.cuni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Thread-Index: Acj9L0YNc6ty7Q1fQ5+AlHCBX5ds7gAALUkg
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808070349.55882.mdontu@bitdefender.com> <20080806213904.37a33a58@infradead.org> <200808111645.48177.mdontu@bitdefender.com> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com> <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com> <20080813102802.GC27074@atrey.karlin.mff.cuni.cz>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Pavel Machek" <pavel@suse.cz>
Cc: <davecb@sun.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "Mihai Don??u" <mdontu@bitdefender.com>,
       "Adrian Bunk" <bunk@kernel.org>, <tvrtko.ursulin@sophos.com>,
       "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-security-module@vger.kernel.org>,
       <malware-list@lists.printk.net>
X-OriginalArrivalTime: 13 Aug 2008 10:46:46.0528 (UTC) FILETIME=[E1E6C000:01C8FD31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Pavel Machek [mailto:pavel@suse.cz]
> Sent: Wednesday, August 13, 2008 6:28 AM
> To: Press, Jonathan
> Cc: davecb@sun.com; Arjan van de Ven; Mihai Don??u; Adrian Bunk;
> tvrtko.ursulin@sophos.com; Greg KH; linux-kernel@vger.kernel.org;
linux-security-
> module@vger.kernel.org; malware-list@lists.printk.net
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
linuxinterfaceforon access
> scanning
> 
> > I think everyone understands one side of the threat model, that is
Linux machines
> being carriers of infections aimed at other platforms.  There are many
ways that
> such infections can be stored, and many ways in which they can be
communicated
> to the target machines.  There are so many that it would not be
effective or efficient
> for each such transfer application to be able to handle its own
malware scanning,
> which is the short statement of why centralized AV protection with
notification
> assistance from the kernel is appropriate.
> >
> 
> No.
> 
> Proposed kernel solution did not work -- there still was write
> vs. read race. You are right that it is not ok for each application to
> do its own malware scanning, but libmalware.so that handles the
> scanning seems very reasonable.
> 
> And as applications _need_ to be modified for the write vs. read race
> to be solved, libmalware.so looks like a way forward.
>
Pavel

I am not sure what you are suggesting, and I may have missed the
libmalware proposal (I don't see any mention of that specific idea in
any other message).  However, just to be clear...  At no point did we
suggest that the kernel would do any scanning.  What we have been
interested in is a mechanism that can allow a scanning application to be
notified by the kernel of specific i/o events, for those events to be
blocked by the kernel until a user-space scan is done, and then the
user-space scan sends back allow or deny, at which point the i/o event
returns to the caller -- either success or error.  This is the only way
that malware can be guaranteed of being detected when it is used (for
local application purposes or for transmission to another platform) or
created.  

Also, a solution that requires applications to be modified will not
work, because there is no way that we would be able to get ALL
applications on the machines to be modified in the required ways.  If
ANY applications are not so modified, then you have an unacceptable
malware hole.  The only solution that really works is one that
guarantees that all applications are involved, which is why the kernel
has to be involved in some way.  It's the only centralized authority
that can stick its nose into all of the required activities.

Whether the specific proposal currently on the table handles all the
issues or not is to me a separate point.


Jon Press
