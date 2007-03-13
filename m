Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXCMETA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXCMETA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXCMETA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:19:00 -0400
Received: from smtpout.mac.com ([17.250.248.184]:53319 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbXCMES6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:18:58 -0400
In-Reply-To: <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org> <1173697024.8014.19.camel@Homer.simpson.net> <20070312110833.GA12835@elte.hu> <200703122223.07048.kernel@kolivas.org> <1173710082.6326.49.camel@Homer.simpson.net> <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DD13278E-1E04-46D2-88E0-14A8B002CD90@mac.com>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Tue, 13 Mar 2007 00:17:35 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 12, 2007, at 11:26:25, Linus Torvalds wrote:
> So "good fairness" really should involve some notion of "work done  
> for others". It's just not very easy to do..

Maybe extend UNIX sockets to add another passable object type vis-a- 
vis SCM_RIGHTS, except in this case "SCM_CPUTIME".  You call  
SCM_CPUTIME with a time value in monotonic real-time nanoseconds  
(duration) and a value out of 100 indicating what percentage of your  
timeslices to give to the process (for the specified duration).  The  
receiving process would be informed of the estimated total number of  
nanoseconds of timeslice that it will be given based on the priority  
of the processes. (Maybe it could prioritize requests?).  The X  
libraries could then properly "pass" CPU time to the X server to help  
with rendering their requests, and the X server could give priority  
to tasks which give up more CPU time than is needed to render their  
data, and penalize those which use more than they give.  Initially  
even if you don't patch the X server you could at least patch the X  
clients to give up CPU to the X server to promote interactivity.

Cheers,
Kyle Moffett

