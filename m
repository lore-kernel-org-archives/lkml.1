Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbYHEO51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbYHEO51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYHEO44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:56:56 -0400
Received: from mail13.ca.com ([141.202.248.42]:52924 "EHLO mail13.ca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbYHEO4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:56:55 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 10:56:55 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface foron access scanning
Date: Tue, 5 Aug 2008 10:41:44 -0400
Message-ID: <2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
In-Reply-To: <1217896374.27684.53.camel@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface foron access scanning
Thread-Index: Acj2ktcZzLYHQ7a2SvWPFQElo0VCFwAcjPoQ
References: <1217883616.27684.19.camel@localhost.localdomain><20080804223249.GA10517@kroah.com> <1217896374.27684.53.camel@localhost.localdomain>
From: "Press, Jonathan" <Jonathan.Press@ca.com>
To: "Eric Paris" <eparis@redhat.com>, "Greg KH" <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, <malware-list@lists.printk.net>
X-OriginalArrivalTime: 05 Aug 2008 14:41:44.0643 (UTC) FILETIME=[61BA6130:01C8F709]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I share the concern here.  The idea that a piece of malware can exclude
itself seems nasty to me.  I am not an expert on writing malware, but it
intuitively seems to me to be a huge opportunity for creativity.  The
argument that it's ok because anything that the malware writes will
eventually be scanned anyway does not reassure me.

Also...  I was one of the people who brought up the idea of a process
exclusion when the requirements list was being developed.  I intended it
as a way that an AV application could exclude specific OTHER processes
by name (as selected by the AV user) -- not as a way that a process
would exclude itself.  I don't think that the implementation here
reflects this goal, which still seems to me to be a requirement.


Jon Press
CA/HCL Internet Security Business Unit




-----Original Message-----
From: malware-list-bounces@dmesg.printk.net
[mailto:malware-list-bounces@dmesg.printk.net] On Behalf Of Eric Paris
Sent: Monday, August 04, 2008 8:33 PM
To: Greg KH
Cc: linux-kernel@vger.kernel.org; malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
foron access scanning

> 
> > 9. Process exclusion
> > --------------------
> > Sometimes it is necessary to exclude certain processes from being
> > intercepted. For example it might be a userspace root kit scanner
which
> > would not be able to find root kits if access to them was blocked by
the
> > on-access scanner.
> > 
> > To facilitate that we have created a special file a process can open
and
> > register itself as excluded. A flag is then put into its kernel
> > structure (task_struct) which makes it excluded from scanning.
> > 
> > This implementation is very simple and provides greatest
performance. In
> > the proposed implementation access to the exclusion device is
controlled
> > though permissions on the device node which are not sufficient.  An
LSM
> > call will need to be made for this type or access in a later patch.
> 
> Heh, so if you want to write a "virus" for Linux, just implement this
> flag.  What's to keep a "rogue" program from telling the kernel that
all
> programs on the system are to be excluded?

Processes can only get this flag one of 2 ways.

1) register as a client to make access decisions
2) echo 1 into the magic file to enable the flag for themselves

A process can only set this flag on itself and having this flag only
means that your opens and closes will not be scanned.  And excluded
program could write a virus and it would not be caught on close, but it
would be caught on the next open.


