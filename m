Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZDREpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZDREpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 00:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbZDREo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 00:44:59 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61253 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZDREo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 00:44:58 -0400
Date: Sat, 18 Apr 2009 00:44:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: raz ben yehuda <raziebe@013.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Subject: Re: Subject: PATCH : offline scheduler
In-reply-to: <1240006279.7801.0.camel@raz>
Message-id: <alpine.LFD.2.00.0904180032000.30751@localhost.localdomain>
References: <1240006279.7801.0.camel@raz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009, raz ben yehuda wrote:

> Len Hello 
> offsched is a platform aimed to assign a service to an off-lined processor.
> Motivation is explained in: 
> http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED.pdf
> Currently I have implemented two services:
> 
> HYBRID REAL TIME LINUX 
> Implemented as a A 1us timer. This timer shows how a true real time system may co-exist with a 
> regular linux server. This way there is no enforcement of a real time system requirements on the
> entire kernel. Full documentation is at:
> http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED-RT.pdf
> 
> RTOP
> This piece of software send system statistics to a remove server.
> The user benefit is that even if the machine is un-accessible (remotely or locally) 
> RTOP still sends system statistics to a remote server. I have showed in a small paper what RTOP is:
> http://sos-linux.svn.sourceforge.net/viewvc/sos-linux/offsched/trunk/Documentation/OFFSCHED-RTOP.pdf
> 
> The patch is mostly a facility for offsched. The exporting of tasklist_lock is because RTOP is implemented as a driver
> and it must lock the tasks list.
> This is the 4-th post. I will be grateful for your reply.
> 
> Signed-off-by: Raz Ben Yehuda <raziebe@013.net.il>
> 
> arch/x86/kernel/process.c |   42 ++++++++++++++++++++++++++++++++++++++++++
> arch/x86/kernel/smpboot.c |   11 +++++++----
> include/linux/cpu.h       |   20 ++++++++++++++++++++
> include/linux/sched.h     |    2 +-
> kernel/cpu.c              |    1 +
> kernel/fork.c             |    6 ++++++
> 6 files changed, 77 insertions(+), 5 deletions(-)


Interesting project Raz, must have been fun to develop!

A couple of comments...

It would probably be of most interest to Ingo and the RT guys on
linux-rt-users@vger.kernel.org rather than the ACPI guys
on linux-acpi@vger.kernel.org. (cc updated)

I don't understand the utility of the "offline timer"
use in section 6.1 of the paper.
With Nehalem, Intel is finally shipping a hardware TSC that is
guaranteed to be C-state, P-state, T-state invarient and not to drift --
so an extremely accurate cycle counter is just an MSR read away
on all cores...

I also don't understand 6.2, the system monitor use --
for the hardware also provides numerous perfmon counters
in hardware for monitoring, and exposing those in a friendly way
seems to me to be a more interesting exercise than
trying to do monitoring in software with a dedicated CPU.

For 6.3, the traffic shaper...
The newer NICs have dedicated hardware to detect and shape
traffic flows -- again, probably much more efficient than
dedicating a general purpose processor...

For RT...
Certainly the performance of a dedicated CPU would be
what the rt kernel would want to strive for.  I guess
the question is if you can measure an actual performance
difference to quanitfy the theoretical beneifts
of the lack of locks, lack of protection etc.

cheers,
Len Brown, Intel Open Source Technology Center


