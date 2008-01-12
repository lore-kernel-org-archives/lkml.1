Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbYALWdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbYALWdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 17:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYALWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 17:33:35 -0500
Received: from rosi.naasa.net ([212.8.0.13]:56933 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbYALWde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 17:33:34 -0500
From: Joerg Platte <jplatte@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Sun, 13 Jan 2008 00:32:30 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801101103.06688.lists@naasa.net> <400029009.12072@ustc.edu.cn>
In-Reply-To: <400029009.12072@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801130032.32495.jplatte@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. Januar 2008 schrieb Fengguang Wu:
> On Thu, Jan 10, 2008 at 11:03:05AM +0100, Joerg Platte wrote:
> > Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> > > > problem, because the iowait problem disappeared today after the
> > > > regular Debian update. I'll try to install the old package versions
> > > > to make it show up again. Maybe that helps to debug it.
> > >
> > > Thank you. I'm running sid, ext2 as rootfs now ;-)
> >
> > The error is back and I'm getting thousands of messages like this with
> > the patched kernel:
> >
> > mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc
> > _M > tw 1024 sk 0 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> > mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc
> > _M > tw 1024 sk 2 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
> > mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc
> > _M > tw 1024 sk 2 requeue_io 301: inode 81441 size 0 at 08:07(sda7)
>
> Joerg, what's the output of `dumpe2fs /dev/sda7` and `lsof|grep /tmp`?

After another reboot I tried to get more information about the konqueror 
process possibly causing the iowait load by using strace -p. Here is the 
output:

gettimeofday({1200180588, 878508}, NULL) = 0
setitimer(ITIMER_VIRTUAL, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
rt_sigaction(SIGVTALRM, {SIG_DFL}, {0xb5cffed0, [VTALRM], SA_RESTART}, 8) = 0
gettimeofday({1200180588, 879942}, NULL) = 0
time(NULL)                              = 1200180588
gettimeofday({1200180588, 880838}, NULL) = 0
gettimeofday({1200180588, 881284}, NULL) = 0
time(NULL)                              = 1200180588
gettimeofday({1200180588, 882131}, NULL) = 0
gettimeofday({1200180588, 882572}, NULL) = 0
ioctl(5, FIONREAD, [0])                 = 0
gettimeofday({1200180588, 883477}, NULL) = 0
select(16, [5 6 7 9 11 14 15], [], [], {0, 150095}) = 0 (Timeout)
gettimeofday({1200180589, 34269}, NULL) = 0
gettimeofday({1200180589, 34885}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 36672}, NULL) = 0
rt_sigaction(SIGVTALRM, {0xb5cffed0, [VTALRM], SA_RESTART}, {SIG_DFL}, 8) = 0
setitimer(ITIMER_VIRTUAL, {it_interval={10, 0}, it_value={5, 0}}, 
{it_interval={0, 0}, it_value={0, 0}}) = 0
gettimeofday({1200180589, 38555}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 39802}, NULL) = 0
setitimer(ITIMER_VIRTUAL, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
rt_sigaction(SIGVTALRM, {SIG_DFL}, {0xb5cffed0, [VTALRM], SA_RESTART}, 8) = 0
gettimeofday({1200180589, 40912}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 42019}, NULL) = 0
gettimeofday({1200180589, 42458}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 43303}, NULL) = 0
gettimeofday({1200180589, 43747}, NULL) = 0
ioctl(5, FIONREAD, [0])                 = 0
gettimeofday({1200180589, 45834}, NULL) = 0
select(16, [5 6 7 9 11 14 15], [], [], {0, 149913}) = 0 (Timeout)
gettimeofday({1200180589, 194815}, NULL) = 0
ioctl(5, FIONREAD, [0])                 = 0
gettimeofday({1200180589, 195730}, NULL) = 0
select(16, [5 6 7 9 11 14 15], [], [], {0, 17}) = 0 (Timeout)
gettimeofday({1200180589, 197555}, NULL) = 0
gettimeofday({1200180589, 198020}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 198884}, NULL) = 0
rt_sigaction(SIGVTALRM, {0xb5cffed0, [VTALRM], SA_RESTART}, {SIG_DFL}, 8) = 0
setitimer(ITIMER_VIRTUAL, {it_interval={10, 0}, it_value={5, 0}}, 
{it_interval={0, 0}, it_value={0, 0}}) = 0
gettimeofday({1200180589, 200702}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 200806}, NULL) = 0
setitimer(ITIMER_VIRTUAL, {it_interval={0, 0}, it_value={0, 0}}, NULL) = 0
rt_sigaction(SIGVTALRM, {SIG_DFL}, {0xb5cffed0, [VTALRM], SA_RESTART}, 8) = 0
gettimeofday({1200180589, 202975}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 203837}, NULL) = 0
gettimeofday({1200180589, 204319}, NULL) = 0
time(NULL)                              = 1200180589
gettimeofday({1200180589, 205169}, NULL) = 0
gettimeofday({1200180589, 205613}, NULL) = 0
ioctl(5, FIONREAD, [0])                 = 0
gettimeofday({1200180589, 206515}, NULL) = 0
select(16, [5 6 7 9 11 14 15], [], [], {0, 149098} <unfinished ...>

Fengguang, do you have any idea what's going wrong here?

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

