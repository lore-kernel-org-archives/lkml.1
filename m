Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbZKDV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbZKDV3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZKDV3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:29:35 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:33892 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838AbZKDV3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:29:35 -0500
MIME-Version: 1.0
Message-ID: <5419f8c1-218e-42d2-991f-e52fc20e5ee4@default>
Date: Wed, 4 Nov 2009 13:28:14 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>, Avi Kivity <avi@redhat.com>
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
In-Reply-To: <1f1b08da0911041319l3687fb58te0a3e1debf185d6c@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4AF1F208.0046:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: john stultz [mailto:johnstul@us.ibm.com]
> On Thu, Oct 29, 2009 at 7:07 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > Out of interest, do you know (and can you relate) why those 
> apps need
> > 100k/sec monotonically increasing timestamps?
> 
> This is sort of tangential, but depending on the need, this might be
> of interest:  Recently I've added a new clock_id,
> CLOCK_MONOTONIC_COARSE (as well as CLOCK_REALTIME_COARSE), which
> return a HZ granular timestamp (same granularity as filesystem
> timestamps). Its very fast to access, since there's no hardware to
> touch, and is accessible via vsyscall.
> 
> The idea being, if your hitting clock_gettime 100k/sec but you really
> don't have the need for nsec granular timestamps, it might provide a
> really nice performance boost.
> 
> Here's the commit:

Hi John --

Yes, possibly of interest.  But does it work with CONFIG_NO_HZ?
(I'm expecting that over time NO_HZ will become widespread
for VM OS's, though interested in if you agree.)

Also very interested in your thoughts about a variation
that returns something similar to a TSC_AUX to notify
caller that the underlying reference clock has/may have
changed.

Dan
