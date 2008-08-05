Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYHESeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYHESeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYHESe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:34:28 -0400
Received: from mail15.ca.com ([208.232.182.54]:45995 "EHLO mail15.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbYHESe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:34:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon access scanning
Date: Tue, 5 Aug 2008 14:34:26 -0400
Message-ID: <2629CC4E1D22A64593B02C43E85553030480743E@USILMS12.ca.com>
In-Reply-To: <20080805112747.2c3c4650@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interfaceforon access scanning
Thread-Index: Acj3KQYiKW5kppa5RvOkWuiKT4LOrAAAB2tQ
References: <1217883616.27684.19.camel@localhost.localdomain><20080804223249.GA10517@kroah.com><1217896374.27684.53.camel@localhost.localdomain><2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com><1217948212.27684.120.camel@localhost.localdomain><2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com><1217956796.11547.12.camel@paris.rdu.redhat.com><20080805103840.1aaa64a5@infradead.org><2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805112747.2c3c4650@infradead.org>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>,
       <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>,
       <linux-security-module@vger.kernel.org>
X-OriginalArrivalTime: 05 Aug 2008 18:34:27.0130 (UTC) FILETIME=[E404D1A0:01C8F729]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You're right...I am not talking about blocking at all -- which may be a
further indication that I am missing the specific point of this thread.

But be that as it may...  I don't want to have to use more than one
interface to get all the events I am interested in.  I want to register
as a client and listen, and get everything I need from the same place.


Also, it seems to me that for my purposes, close is discrete enough.  It
tells me that there is now something out there that should be looked at.


Jon



-----Original Message-----
From: Arjan van de Ven [mailto:arjan@infradead.org] 
Sent: Tuesday, August 05, 2008 2:28 PM
To: Press, Jonathan
Cc: Eric Paris; Greg KH; linux-kernel@vger.kernel.org;
malware-list@lists.printk.net; linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
interfaceforon access scanning

On Tue, 5 Aug 2008 14:04:26 -0400
"Press, Jonathan" <Jonathan.Press@ca.com> wrote:

> 
> However, I want to point out that scanning on close is still an
> integral part of AV protection, even if intercepting opens and execs
> theoretically catches everything.


but close is... very limited in value. Open is a discrete event
traditionally associated withh permission checks.
Close... not so.  (And if you mmap memory, you can then close the file
and still write to it via the mmap)

Lets ask it differently: what will you do if you find something nasty?
You can't fail the close... so why block for it?
And if you don't block for it... all you would need is an asynchronous
notification... something like... inotify

