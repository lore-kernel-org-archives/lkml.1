Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYISNUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYISNUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYISNUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:20:39 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:41286 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYISNUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:20:37 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: doubled idle count
References: <87vdwtfxng.fsf@tac.ki.iif.hu> <48D2AD5E.7040602@goop.org>
Date: Fri, 19 Sep 2008 15:20:28 +0200
In-Reply-To: <48D2AD5E.7040602@goop.org> (Jeremy Fitzhardinge's message of
	"Thu, 18 Sep 2008 12:34:54 -0700")
Message-ID: <87wsh8nug3.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Ferenc Wagner wrote:
>
>> After upgrading a Xen virtual machine to Debian's 2.6.26-4 kernel, I
>> noticed that the idle counter doubled its pace on one of the machines:
>> [...]
>> One out of three machines show this effect, with the exact same kernel
>> and Xen versions (3.2.0, dom0 is Debian's stock Etch 2.6.18 kernel).
>> They aren't hosted by the same machine, though: the misbehaving one is
>> on a different installation with very similar hardware (3 vs 2 GHz).
>> All the guest are paravirtual.
>
> So you're saying that they are identical Xen and guest kernel binaries,
> but one of three is showing doubled idle time?

Now I upgraded another domU, and that also shows this doubling effect,
so I've got two domUs (running on xen2-ha) misbehaving, and other two
(running on xen2) behaving correctly.  On the first:

wferi@xen2-ha:~$ sudo xm info
host                   : xen2-ha
release                : 2.6.18-6-xen-686
version                : #1 SMP Mon Aug 18 12:56:50 UTC 2008
machine                : i686
nr_cpus                : 4
nr_nodes               : 1
cores_per_socket       : 1
threads_per_core       : 2
cpu_mhz                : 3056
hw_caps                : bfebfbff:00000000:00000000:00000080:00004400
total_memory           : 3071
free_memory            : 991
node_to_cpu            : node0:0-3
xen_major              : 3
xen_minor              : 2
xen_extra              : -1
xen_caps               : xen-3.0-x86_32p 
xen_scheduler          : credit
xen_pagesize           : 4096
platform_params        : virt_start=0xf5800000
xen_changeset          : unavailable
cc_compiler            : gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
cc_compile_by          : fs
cc_compile_domain      : debian.org
cc_compile_date        : Mon Mar 10 15:50:27 UTC 2008
xend_config_format     : 4

while on the other the differing lines are:

host                   : xen2
cpu_mhz                : 1993
total_memory           : 4991
free_memory            : 2464

Hope this adds some useful info.
-- 
Regards,
Feri.
