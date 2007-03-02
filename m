Return-Path: <linux-kernel-owner+w=401wt.eu-S933304AbXCBJgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304AbXCBJgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933303AbXCBJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:36:25 -0500
Received: from mail.daysofwonder.com ([213.186.49.53]:42914 "EHLO
	mail.daysofwonder.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933304AbXCBJgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:36:23 -0500
X-Greylist: delayed 1194 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 04:36:22 EST
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional
	writers
From: Brice Figureau <brice+lklm@daysofwonder.com>
To: linux-kernel@vger.kernel.org
Cc: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
In-Reply-To: <loom.20070301T133046-12@post.gmane.org>
References: <45DED819.9040404@hitachi.com>
	 <17888.14958.85897.289141@gargle.gargle.HOWL>
	 <45E380DA.6090509@hitachi.com>   <loom.20070301T133046-12@post.gmane.org>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 10:16:20 +0100
Message-Id: <1172826980.9640.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-03-01 at 12:47 +0000, Leroy van Logchem wrote:
> Tomoki Sekiyama <tomoki.sekiyama.qu <at> hitachi.com> writes:
> > thanks for your comments.
> 
> The default dirty_ratio on most 2.6 kernels tend to be too large imo.
> If you are going to do sustained writes multiple times the size of
> the memory you have at least two problems.
> 
> 1) The precious dentry and inodecache will be dropped leaving you with
> a *very* unresponsive system
> 2) The amount of dirty_pages which need to be flushed to disk is huge,
> taking all VM while the i/o channel takes uninterruptable time to flush it.
> 
> What we really need is a 'cfq' for all processes -especially misbehaving
> ones like dd if=/dev/zero of=/location/large bs=1M count=10000-.
> If you want to DoS the 2.6 kernel, start a ever running dd write and
> you know what I mean. Huge latencies due the fact that all name_to_inode
> caches are lost and have to be fetched from disk again only to be quickly
> flushed again and again. I already explained this disaster scenario with
> Linus, Andrew and Jens; hoping for a auto-tuning solution which takes
> diskspeed per partition into account.
> 
> At the moment we cope with this feature by preserving imported caches with
> sysctl vm.vfs_cache_pressure = 1, vm.dirty_ratio = 2 combined with
> vm.dirty_background_ratio = 1. Some benchmarks may get worse but you have
> a more resiliant server.
> 
> I hope the VM subsystem will cope with applications which do not advise
> what to do with the cached pages. For now we use posix_fadvice DONT_NEED
> as patch to Samba 3 in order to at least be able to write larger then
> memory files without discarding the important slab caches.

I'm sorry to piggy-back this thread.

Could it be what I'm experiencing in the following bugzilla report:
http://bugzilla.kernel.org/show_bug.cgi?id=7372

As I explained in the report, I see this issue only since 2.6.18.
So if your concern is related to mine, what could have changed between
2.6.17 and 2.6.18 related to this?

Unfortunately it is not possible to git bisect this issue as my problem
appears on a live database server. One of the reporter could git-bisect
to a SATA+SCSI patch, but looking at it I can't really see what's wrong.
As soon as I will be able to build a 2.6.18 minus this patch we could
verify both of us are dealing with the same issue or not.

I'm ready to help any kernel developper who wants to look at my issue.
Just ask what debug material you need and I'll try to provide it.

Please CC: me on replies, as I'm not subscribed to the list.

Regards,
-- 
Brice Figureau <brice+lklm@daysofwonder.com>

