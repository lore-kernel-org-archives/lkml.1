Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbZIMXDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbZIMXDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 19:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZIMXDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 19:03:06 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:57025 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZIMXDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 19:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>
	 <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com>
Date: Sun, 13 Sep 2009 19:03:08 -0400
Message-ID: <7e0fb38c0909131603q77141188o47f83325683c2cc@mail.gmail.com>
Subject: Re: [origin tree boot crash] Revert "selinux: clean up avc node cache 
	when disabling selinux"
From: Eric Paris <eparis@parisplace.org>
To: Eric Paris <eparis@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
       Thomas Liu <tliu@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 10:28 PM, Eric Paris <eparis@redhat.com> wrote:
> On Sat, 2009-09-12 at 09:24 +0200, Ingo Molnar wrote:

> Something a lot worse than SELinux here.  I added this exact code and
> got this warning.  Something is wrong in the world of
> kmem_cache_destroy.....
>
> static struct kmem_cache *tmp_cachep;
> tmp_cachep = kmem_cache_create("tmp_cache", sizeof(struct avc_node), 0, SLAB_PANIC, NULL);
>        if (tmp_cachep)
>                kmem_cache_destroy(tmp_cachep);
>
> [    0.006076] ------------[ cut here ]------------
> [    0.007019] WARNING: at lib/kobject.c:595 kobject_put+0x6e/0x80()
> [    0.008011] Hardware name:
> [    0.009006] kobject: '<NULL>' (ffff88001f8da128): is not initialized, yet kobject_put() is being called.
> [    0.010005] Modules linked in:
> [    0.011284] Pid: 0, comm: swapper Not tainted 2.6.31-next-20090911 #17
> [    0.012011] Call Trace:

Just for those playing along at home, I sent a series of 3 patches to
fix the invalid creds test and to clear the avc_node_cachep before
freeing it.
http://marc.info/?l=linux-kernel&m=125281056403544&w=2
http://marc.info/?l=linux-kernel&m=125281056403547&w=2
http://marc.info/?l=linux-kernel&m=125281056403550&w=2

I also bisected at least one problem with kmem_cache_destroy which I
posted the bisect results here
http://marc.info/?l=linux-mm&m=125286686917465&w=2
2a38a002fbee06556489091c30b04746222167e4
