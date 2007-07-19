Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbXGSVGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbXGSVGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXGSVGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:06:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:4996 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759461AbXGSVGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:06:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,558,1175497200"; 
   d="scan'208";a="252522060"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Thu, 19 Jul 2007 14:06:01 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628550DD6@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707191459.20998.nigel@nigel.suspend2.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfJwZQd+7XHhr3jSuGHHnDqnmOWxgAhnO3g
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191218.32730.nigel@nigel.suspend2.net> <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com> <200707191459.20998.nigel@nigel.suspend2.net>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <nigel@suspend2.net>, "Rafael Wysocki" <rjw@sisk.pl>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jul 2007 21:06:02.0853 (UTC) FILETIME=[9D47C150:01C7CA48]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So basically I can not install a signal handler to catch freeze signal
in the process. Right?
Is there any other way to solve the problem I am facing? After resume
some of the system calls are failing in some of my applications with
errno set as EINTR. I wanted to explore a way to not check for this
error all over the place and somehow retry failed system call. Any
ideas?

-----Original Message-----
From: Nigel Cunningham [mailto:nigel@nigel.suspend2.net] 
Sent: Wednesday, July 18, 2007 9:59 PM
To: Agarwal, Lomesh; Rafael Wysocki
Cc: linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

Hi.

On Thursday 19 July 2007 14:09:56 Agarwal, Lomesh wrote:
> Can you point me to code where kernel captures process in signal
> handling and code which runs after suspend to ram is finished?

Sure.

It's in kernel/signal.c (get_signal_to_deliver) for x86 and x86_64, and 
arch/<name>/kernel/signal.c for other arches. The support for other
arches is 
the place x86 & x86_64 used to use - I wonder if they should be going
away 
(Rafael cc'd to raise this point with him).

Regards,

Nigel
-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
