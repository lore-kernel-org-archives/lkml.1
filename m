Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXGTLQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXGTLQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXGTLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:16:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbXGTLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:16:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: which signal is sent to freeze process?
Date: Fri, 20 Jul 2007 13:24:05 +0200
User-Agent: KMail/1.9.5
Cc: nigel@suspend2.net, linux-kernel@vger.kernel.org
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707200819.16100.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD628550F96@scsmsx412.amr.corp.intel.com>
In-Reply-To: <A3258B497F1C1441AD36A2E8B45FD628550F96@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201324.06290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 July 2007 01:22, Agarwal, Lomesh wrote:
> I am using Linux in an embedded platform with x86. Applications don't do
> anything special. The system call which is returning EINTR is poll. Also
> in one of the thread read is returning ENODATA after resume. If I just
> try the system calls again in case of EINTR or ENODATA everything works
> fine.
> From your mail it looks like freezer is not supposed to be interrupting
> system calls. Is that true?

Yes, it is, or at least it should be.

The signal handling is invoked when the process is exiting the kernel space
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
> > So basically I can not install a signal handler to catch freeze signal
> > in the process. Right?
> > Is there any other way to solve the problem I am facing? After resume
> > some of the system calls are failing in some of my applications with
> > errno set as EINTR. I wanted to explore a way to not check for this
> > error all over the place and somehow retry failed system call. Any
> > ideas?
> 
> Well, if you tell us which syscalls are returning with EINTR, maybe we
> can do 
> something on our side. The freezer is supposed to be as transparent as 
> possible to userspace, so it may be the case that we can do something to
> 
> continue waiting or whatever you were doing after the freezing is done.
> 
> Regards,
> 
> Nigel

-- 
"Premature optimization is the root of all evil." - Donald Knuth
