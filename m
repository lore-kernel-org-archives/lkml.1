Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZDDSDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZDDSDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZDDSDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:03:40 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:20183 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZDDSDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cz//P6FiWV6dxKmF/cR9r675UgVaeF1bfx2HQJbCtnX8AmIWJmcLFdRT14CcOtaFSG
         ScSsnEkhU9CikZrO2oz5cK11qQHFego4fVw5oxJA7KgV8KjtZRVjGcCDmihUAvSOBEbL
         GjN6wlBZ9EBNYb+4o0VByuWcGyG6keqIHsFfE=
MIME-Version: 1.0
Date: Sat, 4 Apr 2009 12:03:37 -0600
Message-ID: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
Subject: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

I've been reading a few threads related to IO, such as the recent ext3
fixes from Ted and such.  I didn't want to cloud that thread, so I'm
starting a new one.

Here's something I haven't reported yet, because I haven't been able
to reproduce or identify in any reasonable way, but may be applicable
to this thread.

I am seeing instances where my work load is nil, and I run a process,
which normally does not do a lot of IO.  I get load averages of
30-30-28, with a basic lockup for 10 minutes.  The only thing I can
see that particular app doing is lots of quick IO, mostly reading,
etc.  But, there was no other major workload at the time.  Also, one
fix I have employed to reduce my latencies if I'm under heavy load, is
to use "sync" mount option, or "dirty_bytes".  But, in this instance,
they had absolutely NO AFFECT.  In addition, if I reboot the problem
goes away, for awhile.  Swapping is not occurring when I check swap
after my computer comes back.  So, it seems to me like this problem is
somewhere primarily outside of the FS layer, or at least outside the
FS layer TOO.

FYI: dirty_bytes setting has a good affect for me "usually", but not
in this case.

If the problem was with primarily ext3, why did I not see it in my
2.6.17 kernel on my i686 gentoo Linux box?  Unless there were major
changes to ext3 since then which caused it.  And believe me, I
understand that this latency issue is soooo difficult to find.  Partly
because I'm an idiot and didn't report it when I saw it two years ago.
 If I had reported it then, then you guys would probably be in the
right frame of mind, knowing what changes had just occurred, etc, etc.

If you want, I can give you an strace on the app I ran.  I'm pretty
sure it was the one I ran when the problem was occuring. It's 47K
though.  Hoever, it doesn't appear that any of the system calls took
any significant amount of time, which seems odd to me, seeing the
massive lockup.  And, as far as I know, an app can't cause that kind
of load average of 30 lockup, only the kernel can.  Well, also perhaps
a reniced and ioniced realtime process could.  Am I right in that?

p.s.
Right now, I switched to data=writeback mode.  I'm waiting to see if
this particular problem comes back.  I know that overall latencies do
decrease when using data=writeback.  And, being on a notebook, with a
battery, that option is okay for me.
