Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZEZTVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZEZTVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZEZTV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:21:26 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:49128 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbZEZTVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:21:25 -0400
MIME-Version: 1.0
Message-ID: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default>
Date: Tue, 26 May 2009 12:18:11 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Avi Kivity <avi@redhat.com>, George Dunlap <George.Dunlap@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: [Xen-devel] Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
In-Reply-To: <4A1C3453.6080402@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1 (304090) [OL 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.4A1C4078.00E6:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It will also be 
> interesting to see how far Xen can get along without real memory 
> management (overcommit).

Several implementations of "classic" memory overcommit have been
done for Xen, most recently the Difference Engine work at UCSD.
It is true that none have been merged yet, in part because,
in many real world environments, "generalized" overcommit
often leads to hypervisor swapping, and performance becomes
unacceptable.  (In other words, except in certain limited customer
use models, memory overcommit is a "marketing feature".)

There's also a novel approach, Transcendent Memory (aka "tmem"
see http://oss.oracle.com/projects/tmem).  Though tmem requires the
guest to participate in memory management decisions (thus requiring
a Linux patch), system-wide physical memory efficiency may
improve vs memory deduplication, and hypervisor-based swapping
is not necessary.

> The Linux scheduler already supports multiple scheduling 
> classes.  If we 
> find that none of them will fit our needs, we'll propose a new one.  
> When the need can be demonstrated to be real, and the 
> implementation can 
> be clean, Linux can usually be adapted.

But that's exactly George and Jeremy's point.  KVM will
eventually require changes that clutter Linux for purposes
that are relevant only to a hypervisor.

> > I think if you did an SCO-style audit comparing
> > Linux and Xen 3.4, you'd find a lot less in common than you think.  
> 
> A lot of the arch code is derived from Linux.

Indeed it is, but the operative word is "derived".  In
many cases, the code has been modified to be more applicable
to a hypervisor.  For example, in Xen, tmem uses radix trees
in a way that is similar to Linux but different enough that
the changes would not likely be acceptable in Linux.  The
separation between Xen and Linux allows this diversity
without cluttering Linux.

I think we can all agree that drawing boundaries between
"hypervisor" functionality and "operating system"
functionality is a work in progress and may take many
more years to settle.  In the meantime, there should be
room (and support) for different approaches.

