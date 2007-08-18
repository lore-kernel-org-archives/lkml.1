Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXHRFsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXHRFsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXHRFsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:48:25 -0400
Received: from smtpout.mac.com ([17.250.248.171]:57434 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbXHRFsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:48:24 -0400
In-Reply-To: <46C5F09C.2050600@cfl.rr.com>
References: <106259.96671.qm@web52501.mail.re2.yahoo.com> <Pine.LNX.4.64.0708141546510.22494@blackbox.fnordora.org> <46C2F96D.5030908@partiallystapled.com> <20070815133021.GB9412@csclub.uwaterloo.ca> <ECFEFFF7-0210-4D16-B508-5284FCE58B28@mac.com> <46C33934.7060802@cfl.rr.com> <DE34FF90-3143-4978-BBC5-3CF74B8C3C07@mac.com> <46C3644C.9020102@cfl.rr.com> <87EEB1B3-7FFA-472C-B539-1A7AA2843869@mac.com> <46C37AD4.5060006@cfl.rr.com> <A93D7AFB-6883-48E4-96A9-CAD76E39132E@mac.com> <46C4689C.8020702@cfl.rr.com> <5D526964-3F46-4B6D-A12A-437A7EF5E0D8@mac.com> <46C5BC79.9090204@cfl.rr.com> <1942.1187365183@turing-police.cc.vt.edu> <46C5F09C.2050600@cfl.rr.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DDABDE40-EDA1-421A-A3D9-2CE48802A125@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Michael Tharp <gxti@partiallystapled.com>,
       alan <alan@clueserver.org>, Marc Perkel <mperkel@yahoo.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Sat, 18 Aug 2007 01:48:02 -0400
To: Phillip Susi <psusi@cfl.rr.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 17, 2007, at 15:01:48, Phillip Susi wrote:
> Valdis.Kletnieks@vt.edu wrote:
>> It will become even *more* of a "not that common" if the lock will  
>> block moves and ACL changes *across the filesystem* for  
>> potentially *minutes* at a time.
>
> It will not take anywhere NEAR minutes at a time to update the in  
> memory dentries, more like 50ms.

One last comment:

50ms to update in-memory dentries would be FRIGGING TERRIBLE!!!   
Using Perl, an interpreted language, the following script takes 3.39s  
to run on one of my lower-end systems:

for (0 .. 10000) {
	mkdir "a-$_";
	mkdir "b-$_";
	rename "a-$_", "b-$_";
}

It's not even deleting things afterwards so it's populating a  
directory with ten thousand entries.  We can easily calculate  
10,000/3.39 = 2,949 entries per second, or 0.339 milliseconds per entry.

When I change it to rmdir things instead, the runtime goes down to  
2.89s == 3460 entries/sec == 0.289 milliseconds per entry.

If such a scheme even increases the overhead of a directory rename by  
a hundredth of a millisecond on that box it would easily be a 2-3%  
performance hit.  Given that people tend to kill for 1% performance  
boosts, that's not likely to be a good idea.

Cheers,
Kyle Moffett

