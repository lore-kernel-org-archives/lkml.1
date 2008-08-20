Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYHTOIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYHTOIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbYHTOIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:08:44 -0400
Received: from web82108.mail.mud.yahoo.com ([209.191.84.221]:44418 "HELO
	web82108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752787AbYHTOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:08:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=ltzQ7IngycBnszHp66aSrMo0sz7Jxd66XfgqZpVGc41H0lo0kC6QXLkQaAhSENn70fQkeBga3kjU3wKfsGrf7m/4e78gcPzZxbpal1swxyfxHgPr90LDlaCGu4giQ5ZhRFZ7o6xTmL/DhsjXEHXuctRJGd0hm7qQrvNqfAlsY5A=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Wed, 20 Aug 2008 07:08:42 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <705656.38463.qm@web82108.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > This is true if he reverted just the 3def3d6d... commit, but if he
> > also reverts the similar, and immediately following, 1e934dda...
> > commit, then his 2.6.26 kernel runs fine.
> 
> interesting,
> 
> David, can you try only comment out
> 
> late_initcall(lapic_insert_resource);

Results with v2.6.27-rc3:  hangs in the same way, at the same place;
works with "hpet=disable".


I wondered whether changes since before v2.6.26-rc1 might interfere
with your intention here, so I checked out 1e934dda... and tried
again.

Results with 1e934dda...:  hangs, just like above.


Bill is right:  reverting the changes in 3def3d6d alone will not work 
on my hardware unless I also revert 1e934dda.

I have not (yet) attempted to bring those reverts forward to v2.6.27*
because I have been trying to identify the breakage that 3def3d6d
causes (and because I don't know the right git-fu to apply to my branch
to apply the post-v2.6.26 commits :(  ).


The other user who reported problems said that reverting3def3d6d alone
worked for him.  (I have asked him for more info on his blog, hoping he 
can tell us more... if there is more for him to tell.)  His kernel was 
NOT hanging in the same place as mine:

- mine hangs in inet_init(), after a series of calls that ends with
the hang at synchronize_rcu().

- his hangs (somewhere) inide_scan_pcibus().
[http://www.uwsg.indiana.edu/hypermail/linux/kernel/0805.2/1082.html]

He has a bug report (http://marc.info/?l=linux-kernel&m=121107133101187&w=2)
which lists his hardware as "Abit F-190HD motherboard with a Q6600 CPU".

My hardware -- 2 machines with the same regression -- is quite different:

"fileserver":  ECS AMD690GM-M2 mboard with AMD Athlon X2 4850e
"webserver":  ECS AMD690GM-M2 mboard with AMD Athlon 64 X2 3600+


Thanks,
Dave W.
