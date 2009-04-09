Return-Path: <linux-kernel-owner+w=401wt.eu-S932685AbZDIKbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685AbZDIKbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZDIKbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:31:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZDIKbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:31:19 -0400
Date: Thu, 9 Apr 2009 12:33:22 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
Message-ID: <20090409103322.GA5382@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Corrado Zoccolo <czoccolo@gmail.com>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	Jan Knutar <jk-lkml@sci.fi>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com> <20090408195610.GA5447@fancy-poultry.org> <4e5e476b0904081318h4445556am1a6b0a49c6175719@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e5e476b0904081318h4445556am1a6b0a49c6175719@mail.gmail.com>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1898m143lTt841UPE6nsvPEZ3waaFd1xvqBJDd
 MOgAx7nqKVsHlS3KFH7jgGwjcXvqjTxOdOrK/Je5VHiZUw/b7I
 o1uy1KnzyJZ8dsiJjJa3W/Bfl04DqNy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2009, Corrado Zoccolo wrote: 

> Well, that's not an usual workload for netbooks, where most SSDs are
> currently deployed.

Yes, that's right.

> For usual workloads, that are mostly read, cfq has lower performance
> both in throughput and in latency than deadline.

I don't have a netbook myself, but a Notebook with a singlecore
Intel M-530 CPU and an SSD harddisk, hdparm says:

[....]
ATA device, with non-removable media
Model Number:       OCZ SOLID_SSD
Serial Number:      MK0708520E8AA000B
Firmware Revision:  02.10104
[....]

I did run a short test with fsync-tester, running 10 read-processes
on the disk at the same time. The results between CFQ and DL don't differ
visibly. Maybe I don't get the point, or my tests simply suck, 
but with these results in mind, and considering the fact that when 
the load gets gradually higher, DL will lead to hickups up to ca. 10 secs, 
I would say that DL sucks _bigtime_ , compared to CFQ. 
(Throughput doesn't differ that much either..).


CFQ:

fsync time: 0.0209
fsync time: 0.0204
fsync time: 0.2026
fsync time: 0.2053
fsync time: 0.2036
fsync time: 0.2348
fsync time: 0.2030
fsync time: 0.2051
fsync time: 0.2024
fsync time: 0.2108
fsync time: 0.2025
fsync time: 0.2025
fsync time: 0.2030
fsync time: 0.2006
fsync time: 0.2368
fsync time: 0.2070
fsync time: 0.2009
fsync time: 0.2033
fsync time: 0.2101
fsync time: 0.2054
fsync time: 0.2028
fsync time: 0.2031
fsync time: 0.2073
fsync time: 0.2100
fsync time: 0.2078
fsync time: 0.2093
fsync time: 0.0275
fsync time: 0.0217
fsync time: 0.0298
fsync time: 0.0206
fsync time: 0.0184
fsync time: 0.0201
fsync time: 0.0169
fsync time: 0.0202
fsync time: 0.0186
fsync time: 0.0224
fsync time: 0.0224
fsync time: 0.0214
fsync time: 0.0246

DL

fsync time: 0.0296
fsync time: 0.0223
fsync time: 0.0262
fsync time: 0.0232
fsync time: 0.0230
fsync time: 0.0235
fsync time: 0.0187
fsync time: 0.0284
fsync time: 0.0227
fsync time: 0.0314
fsync time: 0.0236
fsync time: 0.0251
fsync time: 0.0221
fsync time: 0.0279
fsync time: 0.0244
fsync time: 0.0217
fsync time: 0.0248
fsync time: 0.0241
fsync time: 0.0229
fsync time: 0.0212
fsync time: 0.0243
fsync time: 0.0227
fsync time: 0.0257
fsync time: 0.0206
fsync time: 0.0214
fsync time: 0.0255
fsync time: 0.0213
fsync time: 0.0212
fsync time: 0.0266
fsync time: 0.0221
fsync time: 0.0212
fsync time: 0.0246
fsync time: 0.0208
fsync time: 0.0267
fsync time: 0.0220
fsync time: 0.0213
fsync time: 0.0212
fsync time: 0.0264


htd@wildsau:~> bonnie++ -u htd:default -d /testing -s 4004m -m wildsau -n 16:100000:16:64

CFQ

Version 1.01d       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
wildsau     16016M 79619  45 78058  14 28841   7 98629  61 138596  14  1292   3
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    16:100000:16/64   594   7 +++++ +++  1309   6   556   6 +++++ +++   449   4


DL

Version 1.01d       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine       Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec  %CP  /sec %CP
wildsau     16016M 80619  47 78123  14 27842   7 96317  59 135446  14  1383   4
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    16:100000:16/64   601   8 +++++ +++  1288   6   546   6 +++++ +++   432   4



