Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYHWC0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYHWC0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 22:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYHWC0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 22:26:01 -0400
Received: from web82102.mail.mud.yahoo.com ([209.191.84.215]:20972 "HELO
	web82102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751039AbYHWC0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 22:26:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=zolSqm/Xz5ttYxFqwfqMgXluowTmjEc+BSfBdxoe7Kv3Rg5KtfK8Zw6Ht9qpdbSbX1F9cioiONGcDA+yC2GvuFeC4R0p32icH9hvRRNd5Itc0VwWk8GPaNMAsbZKHdOnSBTBSmrwXhn2/YX1e3+QkWC9hdJsgJX4pth5XlYnito=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Fri, 22 Aug 2008 19:25:59 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>,
       Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <773466.71707.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yinghai,

I finally found time to try to get some output using your patch for
resource.c on a kernel that hangs.

Some really good advice came in earlier today:  I can use "vga=1" to
get 80x50 mode during the early boot sequence.  I used that, and made
some alterations to the changes in your patch to squeeze more info
onto the screen.  I also changed KERN_DEBUG to KERN_ERR in your
printk's so that I could decrease the other output by using 
"loglevel=4".

While I cannot see the entire set of output from your debug printk's,
I can see the last 45+ lines that appear before the hang.  The results
were the same as when I used "hpet=disable":  the only difference 
between the working 2.6.25 kernel and the hanging 2.6.27 kernel was 
that the resource named "0000:00:14.0" (fed00000-fed003ff) switched
from "conflict=0" to "conflict=1".

The output from 'cat /proc/iomem' on a non-hanging kernel included
these two lines:

fed00000-fed003ff : HPET 0
  fed00000-fed003ff : 0000:00:14.0


None of this is really new information, since it matches with info
I've already posted.  I just wanted to let you know the results of
your patch on a kernel that hangs.

If I find a way to read the info from the 15-20 lines that scroll 
away on me, and if I find a difference, I'll post that as well.


DW
