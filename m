Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbZKBPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbZKBPrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZKBPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:47:18 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:40881 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755017AbZKBPrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:47:17 -0500
MIME-Version: 1.0
Message-ID: <78f9bb94-fb5d-4fe7-b20f-774bb14e360f@default>
Date: Mon, 2 Nov 2009 07:46:06 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       chris.mason@oracle.com, Ingo Molnar <mingo@redhat.com>
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
	implementation
In-Reply-To: <4AED55C9.9010301@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AEEFECF.01B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't have any public data available for this DB usage, 
> 
> Sorry, that doesn't explain anything.

Well for now just consider the DB usage as another use
of profiling.  But one can easily draw scenarios where
a monotonic timestamp is also used to guarantee transaction
ordering.

> > Search for "flight recorder".  This feature is intended to
> > be enabled all the time, but with non-vsyscall gettimeofday
> > the performance impact is unacceptably high, so they are using  
>
> For profiling work fast timestamping is of course great, but surely 
> there is no monotonicity requirement?

Yes and no.  Monotonicity is a poor substitute for a more
generic mechanism that might provide an indication that a
discontinuity has occurred (forward or backward); if an app
could get both the timestamp AND some kind of "continuity
generation counter" (basically a much more sophisticated
form of TSC_AUX that changes whenever the timestamp is
coming from a different source), perhaps all problems could be solved.

> I don't think we'll be able to provide monotonicity with vsyscall on 
> tsc-broken hosts, so we'll be limited to correcting the tsc frequency 
> after migration for good-tsc hosts.

True, though clock_gettime(CLOCK_MONOTONIC) can provide
the monotonicity where it is required.

Dan
