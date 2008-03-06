Return-Path: <linux-kernel-owner+w=401wt.eu-S932351AbYCFM4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351AbYCFM4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYCFMzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:55:54 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:47054 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751846AbYCFMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:55:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CADh4z0dMQWoK/2dsb2JhbACBVqo5
Date: Thu, 6 Mar 2008 07:55:51 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Srinivasa DS <srinivasa@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       srikar@linux.vnet.ibm.com, SystemTAP <systemtap@sources.redhat.com>
Subject: Re: [BUG] Kprobes fails on 2.6.25-rc3-mm1 (x86) systems, if
	CONFIG_DEBUG_RODATA is set.
Message-ID: <20080306125551.GA1597@Krystal>
References: <200803061811.27555.srinivasa@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200803061811.27555.srinivasa@in.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:55:11 up 6 days,  9:06,  3 users,  load average: 2.49, 1.67,
	1.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Srinivasa DS (srinivasa@in.ibm.com) wrote:
> Insertion of kprobe module causes oops on 2.6.25-rc3-mm1 (x86) systems if we 
> enable CONFIG_DEBUG_RODATA.  While registering the probe, memcpy() fails to 
> copy breakpoint instruction to the instruction address and generates the 
> oops.
> 
> BUG: unable to handle kernel paging request at ffffffff8047d1a7
> IP: [<ffffffff8047ff62>] text_poke+0xa/0x10
> PGD 203067 PUD 207063 PMD 7e191163 PTE 47d161
> Oops: 0003 [1] PREEMPT SMP
> ................................................
> 
> This is because, Mathieu's patch (http://lkml.org/lkml/2008/2/2/226) makes 
> entire text segment as READONLY, if we enable CONFIG_DEBUG_RODATA. 
> 
> So reverting this patch or new patch, which considers kprobes while deciding  
> boundary for setting readonly pages might solve the probelm.
> 

Hi,

Are you running under Xen, lguest, kvm.. ?

Mathieu

> Thanks
>  Srinivasa DS
>  LTC-IBM
>  
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
