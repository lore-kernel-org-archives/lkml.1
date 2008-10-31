Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbYJaOpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbYJaOpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYJaOpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:45:41 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39284 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbYJaOpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:45:40 -0400
Date: Fri, 31 Oct 2008 16:45:38 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Theodore Tso <tytso@mit.edu>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext3 __log_wait_for_space: no transactions
In-Reply-To: <20081031140742.GA17651@mit.edu>
Message-ID: <Pine.SOC.4.64.0810311634580.26420@math.ut.ee>
References: <Pine.SOC.4.64.0810301147310.10441@math.ut.ee> <20081030142103.GA14744@mit.edu>
 <Pine.SOC.4.64.0810302133040.6084@math.ut.ee> <20081031140742.GA17651@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You'll almost certainly get much better performance if you increase
> your journal size.  I should make the crash go away, too, although I
> would like to figure out what is going on so we can fix it.

OK, but let's fix this first.

> In the meantime, you say this happens nightly.  Can you take a look at
> the time when it normally crashes and see if you can correlate it to
> some cron job activity?  Maybe that will be a hint as to what is
> triggering it.

I had a look but didn't find anything very useful. Will reread the logs 
now... it seems useful though:

Oct 30 09:39:01 rhn /USR/SBIN/CRON[21777]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 | xargs -n 200 -r -0 rm)

No hangs on Oct 29.

Oct 28 02:39:01 rhn /USR/SBIN/CRON[5459]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 | xargs -n 200 -r -0 rm)

Oct 27 it did not hang.

Oct 26 14:39:01 rhn /USR/SBIN/CRON[5116]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 | xargs -n 200 -r -0 rm)

Seems to be a hang at Sunday at daytime when nobody was using it but 
cron daemon.

These are all last lines in syslog before the crash, coming from
/etc/cron.d/php5:09,39 *     * * *     root   [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -type f -cmin +$(/usr/lib/php5/maxlifetime) -print0 | xargs -n 200 -r -0 rm
so it runs twice an hour.

-- 
Meelis Roos (mroos@linux.ee)
