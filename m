Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYIMTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYIMTib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbYIMTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 15:38:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYIMTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 15:38:21 -0400
Date: Sat, 13 Sep 2008 12:37:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: Re: [Bug #11500] /proc/net bug related to selinux
Message-Id: <20080913123722.e238ae2a.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.1.10.0809131012310.13073@tundra.namei.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<SpS7rta8n4.A.i9G.ZcsyIB@albercik>
	<alpine.LRH.1.10.0809130812460.12313@tundra.namei.org>
	<20080912152443.c4e59f42.akpm@linux-foundation.org>
	<alpine.LRH.1.10.0809131012310.13073@tundra.namei.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 10:15:43 +1000 (EST) James Morris <jmorris@namei.org> wrote:

> On Fri, 12 Sep 2008, Andrew Morton wrote:
> 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11500
> > > > Subject		: /proc/net bug related to selinux
> > > > Submitter	: Andrew Morton <akpm@linux-foundation.org>
> > > > Date		: 2008-09-04 17:45 (9 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=122055041313270&w=4
> > > 
> > > I think this might be a regression caused by namespace changes which we 
> 
> By which I mean, this was caused by a non-SELinux change to the upstream 
> kernel many, many eons ago.

hm, seems that 2.6.24 is OK but 2.6.25 is not.  I must have missed the
bug when testing 2.6.25-based kernels.

I started a git bisection search but after half an hour I hit bad
bisection breakage: a complete machine hang in fib_rules_init().

> > > addressed in SELinux policy.  Which distro version & policy version is 
> > > this seen with?
> > > 
> > 
> > FC5 on x86_32 and FC6 on x86_64.
> 
> As mentioned in the bugzilla, any related avc messages would be useful.

2.6.25 dmesg: http://userweb.kernel.org/~akpm/dmesg-sony.txt
/var/log/messages: http://userweb.kernel.org/~akpm/messages-sony.txt

The latter includes this:

Sep 13 12:32:43 sony kernel: SELinux:  class key not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  class dccp_socket not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  class memprotect not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  class peer not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  class capability2 not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission open in class dir not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission open in class file not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission open in class chr_file not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission open in class blk_file not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission open in class fifo_file not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission dccp_recv in class node not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission dccp_send in class node not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission recvfrom in class node not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission sendto in class node not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission dccp_recv in class netif not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission dccp_send in class netif not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission ingress in class netif not defined in policy
Sep 13 12:32:43 sony kernel: SELinux:  permission egress in class netif not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission setkeycreate in class process not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission setsockcreate in class process not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission setfcap in class capability not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission polmatch in class association not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission flow_in in class packet not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission flow_out in class packet not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission forward_in in class packet not defined in policy
Sep 13 12:32:44 sony kernel: SELinux:  permission forward_out in class packet not defined in policy
Sep 13 12:32:44 sony kernel: SELinux: the above unknown classes and permissions will be denied
Sep 13 12:32:44 sony kernel: type=1403 audit(1221309118.644:3): policy loaded auid=4294967295 ses=4294967295
Sep 13 12:32:44 sony kernel: type=1400 audit(1221334321.726:4): avc:  denied  { audit_write } for  pid=400 comm="hwclock" capability=29 scontext=system_u:system_r:hwclock_t:s0 tcontext=system_u:system_r:hwclock_t:s0 tclass=capability


Why am I seeing this on two machines and two vanilla-installed distros
but nobody else is reporting it?


