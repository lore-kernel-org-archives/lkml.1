Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZHYT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZHYT2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbZHYT2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:28:00 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:38970 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbZHYT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:28:00 -0400
Date: Tue, 25 Aug 2009 12:27:57 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825192757.GE6456@localdomain>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <4A943290.5080606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A943290.5080606@kernel.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 11:50:56AM -0700, Yinghai Lu wrote:
>Cyrill Gorcunov wrote:
>
>initial apic id and apic id could be different.
>
>and we should use initial apic id to get correct phys pkg id in case BIOS set crazy apic id.
>

Is there a specific bug we are fixing here?  Again, this behavior was
present from atleast 2.6.15-2.6.30 on 'flat' and older 'cluster' apics, and intel
documentation suggests local apic be used.  Is there a specific bios bug
that is being fixed?

(The BIOS is not supposed to set a crazy apic ID.  The BIOS is buggy in that
case --  Quoting section 9.4.6 from Intel System programming guide vol 3A
part 1:

<quote>
9.4.6 Local APIC ID
At power up, system hardware assigns a unique APIC ID to each local APIC on
the system bus (for Pentium 4 and Intel Xeon processors) or on the APIC bus
(for P6 family and Pentium processors). The hardware assigned APIC ID is
based on system topology and includes encoding for socket position and
cluster information (see Figure 7-2).
In MP systems, the local APIC ID is also used as a processor ID by the BIOS
and the operating system....
</quote>)

Thanks,
Kiran
