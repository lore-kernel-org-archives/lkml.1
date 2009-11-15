Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbZKOKEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbZKOKEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZKOKEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:04:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36740 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZKOKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:04:23 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>, Am??rico Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to &proc_dointvec,
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	<20091115065958.GA2459@hack> <20091115081126.GD15432@elte.hu>
	<1258273714.21668.13.camel@Joe-Laptop.home>
	<20091115083951.GA27393@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 15 Nov 2009 02:04:23 -0800
In-Reply-To: <20091115083951.GA27393@elte.hu> (Ingo Molnar's message of "Sun\, 15 Nov 2009 09\:39\:51 +0100")
Message-ID: <m1hbswm7dk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Joe Perches <joe@perches.com> wrote:
>
>> On Sun, 2009-11-15 at 09:11 +0100, Ingo Molnar wrote:
>> > * Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
>> > > On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
>> > > >Seems to be a typo.
>> > > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>> > (Cc:-ed Eric who is running the sysctl tree these days)
>> > Almost everywhere in the kernel we use the shorter version, so all of 
>> > sysctl.c should eventually change to that variant.
>> 
>> It's closer to 50/50, but it's 1 vs 133 in that file.
>> 
>> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*&\s*\w+' * | wc -l
>> 339
>> 
>> $ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*[^&]\s*\w+' * | wc -l
>> 432
>
> I did not mean this specific initialization method of proc_handler, i 
> meant pointers to functions in general.


There was an argument put forward by Alexy (I think) a while ago.  That
argued for the form without the address of operator.

The reason being that without it you can do:
#define proc_dointvec NULL

in a header when sysctl support it compiled out.  Using address of
you wind up with stub functions in sysctl.c to handle the case when
sysctl is compiled out.

It isn't a strong case but since not using & is also shorter and
as Ingo pointed out more common I think no & wins.

Eric
