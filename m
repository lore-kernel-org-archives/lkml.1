Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbYA1W5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbYA1W5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYA1W4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:56:52 -0500
Received: from bizon.gios.gov.pl ([212.244.124.8]:42638 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYA1W4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:56:51 -0500
Date: Mon, 28 Jan 2008 23:56:29 +0100 (CET)
From: Krzysztof Oledzki <ole@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>, cups-bugs <cups-bugs@easysw.com>,
       Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       cups-bugs <cups-bugs@easysw.com>, netfilter-devel@vger.kernel.org
Subject: Re: cups slow on linux-2.6.24
In-Reply-To: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
Message-ID: <Pine.LNX.4.64.0801282348440.30640@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-216295690-1201560989=:30640"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-216295690-1201560989=:30640
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 29 Jan 2008, Jeff Chua wrote:

>
>
> On Jan 28, 2008 7:18 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> I'm sending printing jobs to a network printer (it's actually printing
>> to the localhost simply creating a file), and running this on
>> Linux-2.6.24 will cause the printing to slow down to 1 print every 3
>> seconds after printing 500 times.
>
> I bisected the kernel since the last known good 2.6.23 and zeroed in to t=
his=20
> commit.
>
> commit 17311393f969090ab060540bd9dbe7dc885a76d5
> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date:   Thu Oct 11 14:35:52 2007 -0700
>
>    [NETFILTER]: nf_conntrack_tcp: fix connection reopening
>
>
> Reverting this commit solves the problem.
>
> Version              1000 jobs
> 2.6.23                 90 sec
> 2.6.24              1,492 sec  <=3D=3D with commit
> 2.6.24(patch)          90 sec  <=3D=3D reverted the commit
>

Strange. You stated that 2.6.23.12 is OK, however above patch
was included in 2.6.23.4:

http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.23.4
http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.23.y.git;a=3Dc=
ommitdiff;h=3D0ac38060c5e1e12e851ed3e281597286b57f9ad1

Commit 0ac38060c5e1e12e851ed3e281597286b57f9ad1 combines two fixes from=20
2.6.24:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D17311393f969090ab060540bd9dbe7dc885a76d5
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3Dbc34b841556aad437baf4199744e55500bfa2088

Are you 100% sure that 2.6.23.12 is OK?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-216295690-1201560989=:30640--
