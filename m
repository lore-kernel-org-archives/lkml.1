Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbXGSXW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbXGSXW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbXGSXWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:22:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:17443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbXGSXWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:22:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,558,1175497200"; 
   d="scan'208";a="268369969"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Thu, 19 Jul 2007 16:22:36 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628550F96@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707200819.16100.nigel@nigel.suspend2.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfKUt4P+NlmrEyVQ3Gpl5WRJVCangACE1EQ
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com> <200707200819.16100.nigel@nigel.suspend2.net>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <nigel@suspend2.net>
Cc: "Rafael Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jul 2007 23:22:38.0617 (UTC) FILETIME=[B2561890:01C7CA5B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am using Linux in an embedded platform with x86. Applications don't do
anything special. The system call which is returning EINTR is poll. Also
in one of the thread read is returning ENODATA after resume. If I just
try the system calls again in case of EINTR or ENODATA everything works
fine.
>From your mail it looks like freezer is not supposed to be interrupting
system calls. Is that true?

-----Original Message-----
From: Nigel Cunningham [mailto:nigel@nigel.suspend2.net] 
Sent: Thursday, July 19, 2007 3:19 PM
To: Agarwal, Lomesh
Cc: nigel@suspend2.net; Rafael Wysocki; linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

Hi.

On Friday 20 July 2007 07:06:01 Agarwal, Lomesh wrote:
> So basically I can not install a signal handler to catch freeze signal
> in the process. Right?
> Is there any other way to solve the problem I am facing? After resume
> some of the system calls are failing in some of my applications with
> errno set as EINTR. I wanted to explore a way to not check for this
> error all over the place and somehow retry failed system call. Any
> ideas?

Well, if you tell us which syscalls are returning with EINTR, maybe we
can do 
something on our side. The freezer is supposed to be as transparent as 
possible to userspace, so it may be the case that we can do something to

continue waiting or whatever you were doing after the freezing is done.

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
