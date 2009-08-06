Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZHFQI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZHFQI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZHFQI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:08:56 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47437 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZHFQIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:08:55 -0400
X-SpamScore: -23
X-BigFish: VPS-23(zz1432R14c3M98dN4015L1442Ja4a4kzz1202hzzz32i21ch6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNYQ6F-02-IRT-02
X-M-MSG: 
Date: Thu, 6 Aug 2009 18:08:35 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/5 v4] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090806160835.GD7198@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com> <4A79EA5A.7040308@inria.fr> <20090806104240.GC7198@alberich.amd.com> <4A7ACBAF.8040305@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A7ACBAF.8040305@inria.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 16:08:35.0582 (UTC) FILETIME=[26E111E0:01CA16B0]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 02:25:19PM +0200, Brice Goglin wrote:
> Andreas Herrmann wrote:
> > Of course I thought also to implement it this way because it looks
> > more consistent, but IMHO the patches are less intrusive if this
> > scheme is _not_ used. Instead I kept core_siblings as is ("for
> > historic reasons", nobody needs to accustom to new semantics). And use
> > cpu_node_siblings where it really matters.
> >   
> 
> Well, core_siblings and cpu_node_sibling will only be different on
> Magny-Cours anyway. So even if core_siblings becomes "all cores in
> cpu_node" instead of "all cores in socket", it won't actually break any
> existing setup. I personally prefer having the same kind of semantics
> for all foo_siblings rather than having something with a different
> meaning between core and thread.

You just want to have the user interface adapted to your
semantics. I.e. you want to have following attributes:
(from Documentation/cputopology.txt)

 1) /sys/devices/system/cpu/cpuX/topology/physical_package_id:
 represent the physical package id of  cpu X;
 2) /sys/devices/system/cpu/cpuX/topology/core_id:
 represent the cpu core id to cpu X;
 3) /sys/devices/system/cpu/cpuX/topology/cpu_node_id:
 represent the processor internal node_id to cpu X;
 4) /sys/devices/system/cpu/cpuX/topology/thread_siblings:
 represent the thread siblings to cpu X in the same core;
 5) /sys/devices/system/cpu/cpuX/topology/core_siblings:
 represent the thread siblings to cpu X in the same processor internal node;
 6) /sys/devices/system/cpu/cpuX/topology/cpu_node_siblings:
 represent the thread siblings to cpu X in the same physical package;

 Note: In case of multi-node processors (e.g. Magny-Cours) 5 and 6
 differ. For all other CPUs 5 and 6 provide similar values and
 cpu_node_id is 0.

Ok, I can modify the first two patches accordingly to swap the two
attributes and also provide an update for the documentation file.

(But I will keep the internal identifiers for the cpu_node stuff
as is.)


Thanks,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


