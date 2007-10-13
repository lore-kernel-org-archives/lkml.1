Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbXJMSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbXJMSCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762243AbXJMSB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:01:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762233AbXJMSBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:01:55 -0400
Date: Sat, 13 Oct 2007 11:01:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-mm1
Message-Id: <20071013110103.ae4dd2da.akpm@linux-foundation.org>
In-Reply-To: <4710FC91.6030806@googlemail.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<4710FC91.6030806@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 19:12:49 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> 
> Hi,
> 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > 
> > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> >   to stabilise things for the 2.6.23 merge.
> > 
> >   But that didn't stop all the subsystem maintainers from going nuts, with
> >   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
> >   a bit better.
> 
> Works a bit better right :) At least it boots here but I have a strange problem with it.
> 
> It seems 2.6.23-mm1 kills off java. Every program needs java here does not work anymore telling
> 'my java' installation is incorrect. Also I noticed firefox is acting weird as well thunderbird.
> Gtk apps just random freeze and need be killed with -11.
> 
> Running 'java -version' manually returns nothing , 'java -jar some.jar' does nothing as well. ( not even a error or anything else )
> 
> ( I've also tested sun's java 1.5 and 1.6 and openjre as well all with same result )

We have a screwup in thread handling which might have caused this.

> I only have a WARNING in my dmesg but i don't think this is related to this :
> 
> Oct 13 01:44:52 lara [10722.146448] WARNING: at fs/namespace.c:586 __mntput()
> Oct 13 01:44:52 lara [10722.146478]  [<c0167cb2>] mntput_no_expire+0x5d/0xab
> Oct 13 01:44:52 lara [10722.146503]  [<c01683d1>] sys_umount+0x1f8/0x202
> Oct 13 01:44:52 lara [10722.146511]  [<c010f368>] check_pgt_cache+0x13/0x15
> Oct 13 01:44:52 lara [10722.146529]  [<c0158cd0>] sys_stat64+0xf/0x23
> Oct 13 01:44:52 lara [10722.146549]  [<c0147a9c>] remove_vma+0x31/0x36
> Oct 13 01:44:52 lara [10722.146574]  [<c010fbf6>] do_page_fault+0x180/0x4ea
> Oct 13 01:44:52 lara [10722.146600]  [<c01683e6>] sys_oldumount+0xb/0xe
> Oct 13 01:44:52 lara [10722.146614]  [<c010258e>] sysenter_past_esp+0x5f/0x85
> Oct 13 01:44:52 lara [10722.146639]  [<c02e0000>] xfrm_tmpl_resolve+0x2bd/0x37b
> Oct 13 01:44:52 lara [10722.146656]  =======================

I guess that's the r-o-bind-mounts stuff.

> 
> I also noticed some programs like vlc segfaults :
> 
> vlc[20506]: segfault at 01950000 eip 01950000 esp b4876368 error 4
> 
> Booting 2.6.23 makes all these go away.
> 
> I don't have anything else in my logs. Any idea what patches could cause this problem(s) ?
> 
> Config can be found there -> http://194.231.229.228/2.6.23-mm1-config

what is vlc?
