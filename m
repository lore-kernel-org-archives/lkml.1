Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXHTOYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXHTOYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbXHTOYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:24:44 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:3404 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757259AbXHTOYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:24:43 -0400
Message-ID: <46C9A433.7050509@cfl.rr.com>
Date: Mon, 20 Aug 2007 10:24:51 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Thinking outside the box on file systems
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com> <46C4689C.8020702@cfl.rr.com> <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com> <46C5BC79.9090204@cfl.rr.com> <1942.1187365183@turing-police.cc.vt.edu> <46C5F09C.2050600@cfl.rr.com> <DDABDE40-EDA1-421A-A3D9-2CE48802A125@mac.com>
In-Reply-To: <DDABDE40-EDA1-421A-A3D9-2CE48802A125@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2007 14:24:51.0759 (UTC) FILETIME=[DF024BF0:01C7E335]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15368.001
X-TM-AS-Result: No--6.096500-5.000000-2
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> One last comment:
> 
> 50ms to update in-memory dentries would be FRIGGING TERRIBLE!!!  Using 
> Perl, an interpreted language, the following script takes 3.39s to run 
> on one of my lower-end systems:
> 
> for (0 .. 10000) {
>     mkdir "a-$_";
>     mkdir "b-$_";
>     rename "a-$_", "b-$_";
> }
> 
> It's not even deleting things afterwards so it's populating a directory 
> with ten thousand entries.  We can easily calculate 10,000/3.39 = 2,949 
> entries per second, or 0.339 milliseconds per entry.
> 
> When I change it to rmdir things instead, the runtime goes down to 2.89s 
> == 3460 entries/sec == 0.289 milliseconds per entry.
> 
> If such a scheme even increases the overhead of a directory rename by a 
> hundredth of a millisecond on that box it would easily be a 2-3% 
> performance hit.  Given that people tend to kill for 1% performance 
> boosts, that's not likely to be a good idea.

The question is how many dentries are cached at the time?  And it looks 
like you are just renaming, not moving, so there would be no need to 
recompute the acls at all.

