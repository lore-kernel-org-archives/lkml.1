Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYHNWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYHNWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbYHNWZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:25:40 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:34565 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755215AbYHNWZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:25:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=slVSoFalO6n6hadpZUl++S3ICZiW3Ts1aeTF0ydFyw93g6uccPZkFTQgUST5RyCv/qdF8g18yG+G9dKy73eVAHqgholOv1OXilBQyq9+jAl6H8JCipSK/rKtRYk16SrhNaPTxmsrrb/QEbb4aqU9w5n/Uf5J6Tl23rRA0qwYTe4=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Thu, 14 Aug 2008 15:25:38 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- revert for 2.6.26-rc1 failed
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <798277.39371.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > I do not know how to bisect with your patch if I have a 
> > "bad" but no "good" to start with.  Can you explain how
> > I should proceed when I _do_ get home?  (I can just enabled
> > those config options and try the patch again, but I am
> > confused about the bisect you are asking me to perform.)
> >
> just like the old way doing git-bisect, but before compiling, apply
> the batch, and before git-bisect good or bad, revert the patch.

Let's say I start with this:

1.  'git checkout v2.6.27-rc3'
2.  [apply patch]
3.  build kernel + reboot

If the kernel locks up, you want me to:

4.  [un-apply the patch]
5.  'git bisect start'
6.  'git bisect bad'

Of course, we both hope that the kernel will NOT lock up,
but let's say it does.  My confusion is the what step to take
next.  To use 'git bisect' I have to select the next kernel
version manually until I find a "good" and "bad" version...
then git can automatically do its bisecting process.

I assume you would want me to choose a previous kernel
version, like "v2.6.27-rc2".  If I keep getting "bad"
kernels, do you want me to just keep using earlier
versions... until the patch will no longer apply?

I must have misunderstood the git man pages:  I thought
that the purpose of bisecting was to find a commit that
caused a problem, which presumes that you already know
a version of the kernel which works and a version which
does not work.  Have I misunderstood?


Dave W.

PS:  My apologies if I seem obtuse.  Before this LKML
thread, I had only used git once -- and only to do
a checkout... no higher functionality like bisecting,
branching, merging, etc.  I am learning quickly, but
frankly I am baffled about how to do what you are 
asking!

