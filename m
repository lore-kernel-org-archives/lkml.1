Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbXJRVg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbXJRVg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXJRVgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:36:50 -0400
Received: from smtp.ono.com ([62.42.230.12]:60700 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755874AbXJRVgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:36:50 -0400
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 17:36:49 EDT
Date: Thu, 18 Oct 2007 23:31:13 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Denys Vlasenko <vda.linux@googlemail.com>,
       "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Message-ID: <20071018233113.3ba51f2e@werewolf>
In-Reply-To: <200710141558.27156.vda.linux@googlemail.com>
References: <200710141558.27156.vda.linux@googlemail.com>
X-Mailer: Claws Mail 3.0.2cvs76 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 15:58:26 +0100, Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Hi,
> 
> Following patches debloat drivers/scsi/aic7xxx/*.
> I also had to add prototypes for ahc_lookup_scb
> and ahd_lookup_scb to .h files.
> 

Sorry for the late replay, but.. working fine on 

annwn:~# lspci | grep Adap
03:02.0 SCSI storage controller: Adaptec ASC-29320 U320 (rev 03)
03:02.1 SCSI storage controller: Adaptec ASC-29320 U320 (rev 03)
annwn:~# lsscsi -H
[1]    aic79xx       
[2]    aic79xx       

with
annwn:~# lsscsi
[2:0:0:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdb
[2:0:1:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdc
[2:0:2:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdd
[2:0:3:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sde

and giving up to 200Mb/s on a pretty old mobo (see cached reads) with raid5:

annwn:~# hdparm -tT /dev/sd[bcde]

/dev/sdb:
 Timing cached reads:   950 MB in  2.00 seconds = 474.23 MB/sec
 Timing buffered disk reads:  228 MB in  3.00 seconds =  75.93 MB/sec

/dev/sdc:
 Timing cached reads:   1020 MB in  2.00 seconds = 510.01 MB/sec
 Timing buffered disk reads:  228 MB in  3.01 seconds =  75.76 MB/sec

/dev/sdd:
 Timing cached reads:   1022 MB in  2.00 seconds = 510.69 MB/sec
 Timing buffered disk reads:  228 MB in  3.01 seconds =  75.79 MB/sec

/dev/sde:
 Timing cached reads:   1016 MB in  2.00 seconds = 507.92 MB/sec
 Timing buffered disk reads:  228 MB in  3.02 seconds =  75.48 MB/sec
annwn:~# hdparm -tT /dev/md0

/dev/md0:
 Timing cached reads:   1020 MB in  2.00 seconds = 509.96 MB/sec
 Timing buffered disk reads:  602 MB in  3.01 seconds = 199.84 MB/sec


--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam01 (gcc 4.2.2 20070909 (4.2.2-0.RC.1mdv2008.0)) SMP PREEMPT
09 F9 11 02 9D 74 E3 5B D8 41 56 C5 63 56 88 C0
