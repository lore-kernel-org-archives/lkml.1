Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYCANb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYCANb4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 08:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYCANbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 08:31:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:14168 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbYCANbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 08:31:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j3dK4Xa8HA5C2HxLxNhtGdomdm7C8kIn74ASOtdV9JCfF7Ju3rfF8u/UGn82AuKWgZRpCfIOpHQa3jztFGHQ0GYcWiarQCgTYp2S++RHT+Hn8huD41lKx3t7HBINqOdMH2ZePimM8uUk1DL8z4817MfofHHCH68ZdsymrWJm6RY=
Message-ID: <74d8fc520803010531h3453ca91m4521f6bd94b1f5ad@mail.gmail.com>
Date: Sat, 1 Mar 2008 13:31:41 +0000
From: "Gordon Mckeown" <gordon.mckeown@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Very high IOWait during all disk activity
Cc: "Tomasz Chmielewski" <mangoo@wpkg.org>
In-Reply-To: <47C82C2A.5000301@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47C82244.60307@wpkg.org>
	 <74d8fc520802290747o2c97992ar7af2b8c295fe2fb2@mail.gmail.com>
	 <47C82C2A.5000301@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 4:00 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:

>  Also, you gave too few details to say anything meaningful, really (did
>  you drop cache on both systems before starting copying? did you sync
>  after copying on both systems to see how long does it take? etc.).

Tomasz, many thanks for your comments. My original testing of Windows
against Linux was done in a very non-scientific way (as my main
concern was with IOWaits).

I have now performed some slightly more scientific comparisons between
the Windows and Linux copy operations. I think the main flaw in my
original Windows test was that I used Explorer to do the copy, and I
believe this has a tendency to hide the true length of the copy
operation.

Turning off the write cache on Windows resulted in a massive decrease
in performance, so I simply listened to the disk heads after the copy
had completed to confirm that the disk was idle (not perfect, I know).
On Linux I ran a sync after the copy, but it took less than 1 second
to complete, so I have ignored it in my results.

I ran the tests again using perfmon to monitor CPU usage, timeit.exe
from the Win2k3 resource kit to time the copy, and the xcopy command
to run the copies themselves. With these tests, Linux actually copied
a 3387MB file very slightly quicker than Windows.

It did, however, still highlight quite a difference in CPU usage.
Perfmon only recorded total CPU usage (i.e. user + system), so I
compared this against the user+system figures from vmstat.

Average CPU usage for Windows during the copies was 12%. Average CPU
usage for Linux during the copies was almost 40%!

Command used on Linux:

time cp testdir1/testfile1 testdir2/

Here's a quick sample of the vmstat output during one of the copy operations:

 procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
0  3  34780  12688   2404 756888    0    0 19856 58148  411  988  4 40  0 56
 0  2  34780  11448   2432 759284    0    0 16724   152  400 1049  1 26  0 73
 0  1  34780  12632   2472 757456    0    0 36580 16460  525 1256  3 54  0 43
 2  1  34780  13188   2500 756704    0    0 21400 20720  444 1071  3 34  0 63
 0  1  34780  12104   2508 757368    0    0 23700 24864  430 1043  1 36  0 63
 0  2  34780  11324   2512 757892    0    0 20500 59596  436 1073  2 43  0 55
 0  2  34780  11700   2532 758432    0    0 20500     0  407 1100  1 29  0 70
 0  1  34780  11592   2568 758444    0    0 32804 15148  512 1303  2 48  0 50

As you can see, in this case there's a pretty huge amount of system CPU usage.

I'll run some more tests with different filesystems to see if this is
related to the use of EXT3 specifically.

Cheers,

Gordon.
