Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXIYPKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXIYPKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 11:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXIYPKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 11:10:33 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34251 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXIYPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 11:10:32 -0400
Message-ID: <46F924E3.50205@davidnewall.com>
Date: Wed, 26 Sep 2007 00:40:27 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Chroot bug (was: sys_chroot+sys_fchdir Fix)
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com>
In-Reply-To: <46F91417.9050600@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miloslav Semler pointed out that a root process can chdir("..") out of 
its chroot.  Although this is documented in the man page, it conflicts 
with the essential function, which is to change the root directory of 
the process.  In addition to any creative uses, for example Philipp 
Marek's loading dynamic libraries, it seems clear that the prime purpose 
of chroot is to aid security.  Being able to cd your way out is handy 
for the bad guys, but the good guys don't need it; there are a thousand 
better, safer solutions.

If there truly is a need to be able to pop in and out of a chroot, then 
the solution should be obvious, such as with real versus effective user 
and group ids.  An important quality of a solution would be a way to fix 
that essential function: to set the root in such a way that you can no 
longer pop out.  But that is a separate question.

The question: is chroot buggy?  I'm pleased to turn to SCO for an 
independent definition for chroot, from which I get the following:

http://osr600doc.sco.com/en/man/html.S/chroot.S.html:
>
> The *..* entry in the root directory is interpreted to mean the root 
> directory itself. Thus, *..* cannot be used to access files outside 
> the subtree rooted at the root directory.
>

I argue chroot is buggy.  Miloslav's patch might not be the right 
solution, but he has the right idea (i.e. fix it.)
