Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZGKOHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZGKOHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 10:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZGKOHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 10:07:23 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:51817 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZGKOHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 10:07:23 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	<87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	<87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	<200907092203.10294.rjw@sisk.pl>
	<1247171295.1905.5.camel@johannes.local>
Date: Sat, 11 Jul 2009 16:07:10 +0200
In-Reply-To: <1247171295.1905.5.camel@johannes.local> (Johannes Berg's message
	of "Thu, 09 Jul 2009 22:28:15 +0200")
Message-ID: <87prc78ga9.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:
> On Thu, 2009-07-09 at 22:03 +0200, Rafael J. Wysocki wrote:
>> On Thursday 09 July 2009, Jan Scholz wrote:
>> > Hi,
>> > 
>> > I have just checked this on v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547
>> > (I wanted to test this on v2.6.31-rc2 as well, but there I had other
>> > suspend-issues that are fixed in todays v2.6.31-rc2-214-g34f2547)
>> > 
>> > For both v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547 suspend to ram fails
>> > with the test procedure described below, but it works fine when I revert
>> > commit 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7
>> >  "mac80211: cancel/restart all timers across suspend/resume"
>> 
>> Thanks for the update.
>> 
>> Johannes, do you have any idea what can go wrong here?
>
> Not really, no. __ieee80211_suspend isn't holding any locks that the
> cancel_work_sync() calls could require or so afaict...
>
> Jan, can you run with console_suspend=0 (or whatever it is now, Rafael
> will correct me if I'm wrong) that should work on your platform, and put
> a bunch of printk calls into __ieee80211_suspend in net/mac80211/pm.c to
> see where in there it's hanging?

Did that, seems like it hangs in
  drv_remove_interface(local, &conf);

Jan
