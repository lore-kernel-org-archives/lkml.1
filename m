Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZKBP3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZKBP3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZKBP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:29:41 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:56179 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZKBP3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:29:40 -0500
MIME-Version: 1.0
Message-ID: <861f0a3e-8d6f-473e-a67d-80e46343fedd@default>
Date: Mon, 2 Nov 2009 07:28:21 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       kurt.hackel@oracle.com, Glauber Costa <glommer@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>, zach.brown@oracle.com,
       Ingo Molnar <mingo@redhat.com>, chris.mason@oracle.com
Subject: RE: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall
 implementation
In-Reply-To: <4AED54D1.6070706@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4AEEFABB.007B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Avi Kivity [mailto:avi@redhat.com]
> 
> On 10/29/2009 06:15 PM, Dan Magenheimer wrote:
> > On a related note, though some topic drift, many of
> > the problems that occur in virtualization due to migration
> > could be better addressed if Linux had an architected
> > interface to allow it to be signaled if a migration
> > occurred, and if Linux could signal applications of
> > the same.  I don't have any cycles (pun intended) to
> > think about this right now, but if anyone else starts
> > looking at it, I'd love to be cc'ed.   
> 
> IMO that's not a good direction.  The hypervisor should not depend on 
> the guest for migration (the guest may be broken, or 
> malicious, or being 
> debugged, or slow).  So the notification must be asynchronous, which 
> means that it will only be delivered to applications after 
> migration has 
> completed.

I definitely agree that the hypervisor can't wait for a guest
to respond.

You've likely thought through this a lot more than I have,
but I was thinking that if the kernel received the notification
as some form of interrupt, it could determine immediately
if any running threads had registered for "SIG_MIGRATE"
and deliver the signal synchronously.

> Instead of a "migration has occured, run for the hills" signal we're 
> better of finding out why applications want to know about 
> this event and 
> addressing specific needs.

Perhaps.  It certainly isn't warranted for this one
special case of timestamp handling.  But I'll bet 5-10 years
from now, after we've handled a few special cases, we'll
wish that we would have handled it more generically.

Dan
