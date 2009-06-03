Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZFCBCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZFCBCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZFCBCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:02:42 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:51457 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZFCBCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:02:41 -0400
Date: Tue, 2 Jun 2009 18:00:00 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090603010000.GE31976@mail.oracle.com>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	David Miller <davem@davemloft.net>,
	"jeremy@goop.org" <jeremy@goop.org>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	"avi@redhat.com" <avi@redhat.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Keir Fraser <Keir.Fraser@eu.citrix.com>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
	Ian Pratt <Ian.Pratt@eu.citrix.com>,
	"xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
	ksrinivasan <ksrinivasan@novell.com>,
	"EAnderson@novell.com" <EAnderson@novell.com>,
	"wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
	Stephen Spector <stephen.spector@citrix.com>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>,
	"npiggin@suse.de" <npiggin@suse.de>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org> <20090602232843.GA6577@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602232843.GA6577@elte.hu>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A25CB40.00CA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Speaking as me, no regard to $EMPLOYER ]

On Wed, Jun 03, 2009 at 01:28:43AM +0200, Ingo Molnar wrote:
> A lot of Xen legacies could be dropped: the crazy ring1 hack on 
> 32-bit, the various wide interfaces to make pure-software 
> virtualization limp along. All major CPUs shipped with hardware 
> virtualization support in the past 2-3 years, so the availability of 
> VMX and SVM can be taken for granted for such a project.

	The biggest reason I personally want Xen to be in mainline is
PVM.  Dropping PVM is, to me, pretty much saying "let's merge Xen
without taking the useful parts."
	I have only two large machines I control.  They're too big to
run as single hosts - it's a waste - but I can leverage cluster testing
by virtualizing them.
	The first machine has HVM support.  The early kind.  It's about
2 years old.  It's so dreadfully slow that I had to go to PVM.  That
runs at very good speeds and I've stopped noticing the virtualization.
The only problem I have is managing the hypervisor bits, because they're
out of tree.
	Now, perhaps that could be fixed.  Someone told me that older
HVM boxen can't be fixed; you need a very recent VMX/SVM to perform
well.  But if it is fixable, then perhaps future plans shouldn't worry
about it.
	The second machine is pre-HVM by a short period.  It is not even
three years old.  I can't run HVM on it, at all.  I can either run PVM
or I can't virtualize.  It has fast CPUs and many GB of RAM.  I can do
an entire four node cluster test on it, with serious (read, memory
intensive) software.  In a PVM-less world, this machine becomes a
single cluster node, and I have to go find three more machines.  Of
course, if I had infinite machines, I wouldn't be worrying about this at
all.
	So I want to see PVM continue for a long time.  I'd like it to
be something I can get with mainline Linux.  I don't care if it is dom0,
dom0 and the hypervisor, whatever.  I just don't want to have to be
patching out-of-tree patches for a pretty basic functionality.
	I don't see 2-3 years as a time frame to assume "everyone has
one."  Otherwise, why does Linux have code for x86_32?  Everyone's had a
64bit system for at least that long.  Sure, that's a straw man.  It goes
both ways.
	Like Chris said, if we have technical hurdles for Xen to cross,
let's get them out in the open and fixed.  If previous Xen developer
interaction has left a bad taste in people's mouths, then the current
crew has to make it up to us.  But we have to be willing to notice
they're doing so.
	At the end of the day, I want to use Linux on my systems.

Joel

-- 

"I almost ran over an angel
 He had a nice big fat cigar.
 'In a sense,' he said, 'You're alone here
 So if you jump, you'd best jump far.'"

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
