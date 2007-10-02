Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbXJBLHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbXJBLHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXJBLHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:07:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48067 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbXJBLHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:07:44 -0400
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 13:07:38 +0100
Message-Id: <1191326858.28962.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 20:41 -0700, Linus Torvalds wrote:
> I said I was hoping that -rc8 was the last -rc, and I hate doing this, but 
> we've had more changes since -rc8 than we had in -rc8. And while most of 
> them are pretty trivial, I really couldn't face doing a 2.6.23 release and 
> take the risk of some really stupid brown-paper-bag thing.
> 

Dirt. Booting with "profile=sleep,2" is broken in 2.6.23-rc9 and
2.6.23-rc8 but working in 2.6.22. I was checking it out as part of a
discussion in another thread and noticed it broken in -mm as well
(2.6.23-rc8-mm2). Bisect is in progress but suggestions as to the prime
candidates are welcome or preferably, pointing out that I'm an idiot
because I missed twiddling some config change.

2.6.22 output
gringo:~# readprofile | sort -rn
 69604 total                                      0.0309
 27287 m_start                                  243.6339
 16430 sync_page                                205.3750
 13161 sync_buffer                              205.6406
  4035 sys_init_module                            0.6121
  2842 msleep                                    88.8125
  2573 call_usermodehelper_keys                  10.7208
  1554 ps2_sendbyte                               6.0703
   803 log_wait_commit                            2.7882
   378 do_lookup                                  0.9844
   160 do_get_write_access                        0.1111
    89 synchronize_rcu                            1.3906
    76 ps2_command                                0.0792
    66 ide_do_drive_cmd                           0.2292
    59 do_fork                                    0.1085
    54 congestion_wait                            0.3750
    29 __rtnl_unlock                              1.8125
     4 kthread                                    0.0357
     2 *unknown*
     2 journal_stop                               0.0038
     1 kthreadd                                   0.0035
     1 kthread_create                             0.0063

latest git output
gringo:~# readprofile
     0 *unknown*
     0 total                                      0.0000

I checked the obvious stuff like DEBUG options being set,
CONFIG_PROFILING being set etc.

> So there's a final -rc out there, and right now my plan is to make this 
> series really short, and release 2.6.23 in a few days. So please do give 
> it a last good testing, and holler about any issues you find!
> 
> This is also a good time to warn about the fact that we're doing the x86 
> merge very soon (as in the next day or two) after 2.6.23 is out, so if you 
> have pending patches for the next series that touch arch/i386 or x86-64, 
> you should get in touch with Thomas Gleixner and Ingo Molnar, who are the 
> keepers of the merge scripts, and will help you prepare..
> 
> Doing it as early as possible in the 2.6.24-rc4 series (basically I'll do 
> it first thing) will mean that we'll have the maximum amount of time to 
> sort out any issues, and the thing is, Thomas and Ingo already have a tree 
> ready to go, so people can check their work against that, and don't need 
> to think that they have to do any fixups after it his *my* tree. It would 
> be much better if everybody was just ready for it, and not taken by 
> surprise.
> 
> In other words, people who know they may be affected and would want to 
> prepare can look at (for example)
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-x86.git x86
> 
> and generally get ready for the switch-over. 
> 
> 			Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

