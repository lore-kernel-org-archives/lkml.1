Return-Path: <linux-kernel-owner+w=401wt.eu-S1762368AbYHESEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762368AbYHESEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbYHESE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:04:28 -0400
Received: from mail14.ca.com ([208.232.182.53]:1992 "EHLO mail14.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYHESE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:04:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon access scanning
Date: Tue, 5 Aug 2008 14:04:26 -0400
Message-ID: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
In-Reply-To: <20080805103840.1aaa64a5@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon access scanning
Thread-Index: Acj3IiNKM+ndVSeeTQCuIYWdW/xZVAAAaTMg
References: <1217883616.27684.19.camel@localhost.localdomain><20080804223249.GA10517@kroah.com><1217896374.27684.53.camel@localhost.localdomain><2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com><1217948212.27684.120.camel@localhost.localdomain><2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com><1217956796.11547.12.camel@paris.rdu.redhat.com> <20080805103840.1aaa64a5@infradead.org>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Arjan van de Ven" <arjan@infradead.org>, "Eric Paris" <eparis@redhat.com>
Cc: "Greg KH" <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 18:04:27.0229 (UTC) FILETIME=[B331B8D0:01C8F725]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure if this is off the direct idea of this thread, or if I am
possibly missing the whole point.

However, I want to point out that scanning on close is still an integral
part of AV protection, even if intercepting opens and execs
theoretically catches everything.

You can say that there are four parts to the malware life cycle --
getting on a machine, residing there, causing local damage, and
propagating elsewhere.  It is part of the philosophy of AV protection
that you do everything you can to prevent all of them.  That's why there
are scans on close, scheduled scans, and scans on open.  Most of our
users employ all three and do not rely on one or two.  If an infection
arrives on a machine and finds a home because it is assumed that it will
be caught when it is opened for use, then it is just one more compromise
away from doing damage and/or spreading.


Jon Press



-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Tuesday, August 05, 2008 1:39 PM
To: Eric Paris
Cc: Press, Jonathan; Greg KH; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
interfaceforon access scanning

On Tue, 05 Aug 2008 13:19:56 -0400
Eric Paris <eparis@redhat.com> wrote:

> If you can outline the design of a better method that meets your needs
> I'd be glad to try to code it.  In your mind how do you see programs
> being able to exclude others while not being a security risk? 


ok so lets be specific.
You are trying to prevent an application from opening a "damaged" file,
or from someone starting a "damaged" file.
You are not trying to prevent anything once you have executed a damaged
file; once you execute one of these for this part it's game over (to
limit the damage other tools like selinux exist, but are outside the
scope of talpa).

So... as long as /sbin/init isn't compromised... intercepting exec and
open (in all variants) is all you need.

And this can be done from userland with the preload: the "workaround"
from the preload assumes you've already executed malicious code, which
is outside of your protection scope.

What am I missing?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

