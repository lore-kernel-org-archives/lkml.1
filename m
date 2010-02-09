Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0BILkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 06:40:05 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:5647 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752153Ab0BILkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 06:40:01 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 06:40:00 EST
Message-ID: <4B71475A.8020209@draigBrady.com>
Date: Tue, 09 Feb 2010 11:30:34 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/10 22:49, Linus Torvalds wrote:
> Oh, and I forgot to ask one thing I had intended to ask in the release
> notes..
>
> Do people really care about the old-fashioned tar.gz and patch.gz files?
> I've always uploaded the tar-files and patches compressed with gzip,
> because that's the "traditional" way, and then we have a script that also
> re-compresses things as 'bz2' because it compresses better and many people
> are bandwidth-limited and much prefer the better compression.
>
> Of course, if you really care about bandwidth, you're better off just
> fetching the git trees instead, but the question for non-git users is:
>
>     Would it be ok to _only_ have the 'bz2' patches and tar-balls?
>
> Having two copies of every large file seems silly, if nobody really
> requires the traditional .gz format..

For reference, we've stopped releasing bz2 files for the coreutils project.
We use gz for compatibility and xz for increased compression ratio/decompression speed.

$ rpm -q xz gzip bzip2
xz-4.999.9-0.1.beta.20091007git.fc11.i586
gzip-1.3.12-10.fc11.i586
bzip2-1.0.5-5.fc11.i586

$ bzip2 -dc linux-2.6.33-rc7.tar.bz2 | xz > linux-2.6.33-rc7.tar.xz
$ xz -dc linux-2.6.33-rc7.tar.xz | gzip > linux-2.6.33-rc7.tar.gz
$ l
-rw-rw-r-- 1 padraig 66,191,954 Feb  6 22:27 linux-2.6.33-rc7.tar.bz2
-rw-rw-r-- 1 padraig 56,347,392 Feb  9 11:17 linux-2.6.33-rc7.tar.xz
-rw-rw-r-- 1 padraig 85,300,209 Feb  9 11:20 linux-2.6.33-rc7.tar.gz

$ time bzip2 -dc linux-2.6.33-rc7.tar.bz2 >/dev/null
real    0m30.132s
$ time gzip -dc linux-2.6.33-rc7.tar.gz >/dev/null
real    0m4.996s
$ time xz -dc linux-2.6.33-rc7.tar.xz >/dev/null
real    0m11.003s

cheers,
Pádraig.
