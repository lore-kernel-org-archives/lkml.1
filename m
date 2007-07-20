Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXGTSIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXGTSIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbXGTSID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:08:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:23681 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbXGTSH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="252875852"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Fri, 20 Jul 2007 11:07:57 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD62858CCA1@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707201324.06290.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfKv2S+yoavUciOSf+4HUfj3T4EPwAOGrAg
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707200819.16100.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD628550F96@scsmsx412.amr.corp.intel.com> <200707201324.06290.rjw@sisk.pl>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: <nigel@suspend2.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jul 2007 18:07:58.0943 (UTC) FILETIME=[E79636F0:01C7CAF8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you suggest a way I can debug the issue why I am getting EINTR error
for system calls in resuming? What else can cause the system call
failure with EINTR?

-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Friday, July 20, 2007 4:24 AM
To: Agarwal, Lomesh
Cc: nigel@suspend2.net; linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

On Friday, 20 July 2007 01:22, Agarwal, Lomesh wrote:
> I am using Linux in an embedded platform with x86. Applications don't
do
> anything special. The system call which is returning EINTR is poll.
Also
> in one of the thread read is returning ENODATA after resume. If I just
> try the system calls again in case of EINTR or ENODATA everything
works
> fine.
> From your mail it looks like freezer is not supposed to be
interrupting
> system calls. Is that true?

Yes, it is, or at least it should be.

The signal handling is invoked when the process is exiting the kernel
space
and it shouldn't affect the execution or results of system calls.

Greetings,
Rafael


> -----Original Message-----
> From: Nigel Cunningham [mailto:nigel@nigel.suspend2.net] 
> Sent: Thursday, July 19, 2007 3:19 PM
> To: Agarwal, Lomesh
> Cc: nigel@suspend2.net; Rafael Wysocki; linux-kernel@vger.kernel.org
> Subject: Re: which signal is sent to freeze process?
> 
> Hi.
> 
> On Friday 20 July 2007 07:06:01 Agarwal, Lomesh wrote:
> > So basically I can not install a signal handler to catch freeze
signal
> > in the process. Right?
> > Is there any other way to solve the problem I am facing? After
resume
> > some of the system calls are failing in some of my applications with
> > errno set as EINTR. I wanted to explore a way to not check for this
> > error all over the place and somehow retry failed system call. Any
> > ideas?
> 
> Well, if you tell us which syscalls are returning with EINTR, maybe we
> can do 
> something on our side. The freezer is supposed to be as transparent as

> possible to userspace, so it may be the case that we can do something
to
> 
> continue waiting or whatever you were doing after the freezing is
done.
> 
> Regards,
> 
> Nigel

-- 
"Premature optimization is the root of all evil." - Donald Knuth
