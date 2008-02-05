Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYBERKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYBERKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYBERKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:10:36 -0500
Received: from fwil.voltaire.com ([193.47.165.2]:24842 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751981AbYBERKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:10:35 -0500
Message-ID: <47A89889.9060701@Voltaire.COM>
Date: Tue, 05 Feb 2008 19:10:33 +0200
From: Erez Zilber <erezz@Voltaire.COM>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       James.Bottomley@hansenpartnership.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
In-Reply-To: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Feb 2008 17:10:33.0324 (UTC) FILETIME=[04747AC0:01C8681A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> As you probably know there is a trend in enterprise computing towards
> networked storage. This is illustrated by the emergence during the
> past few years of standards like SRP (SCSI RDMA Protocol), iSCSI
> (Internet SCSI) and iSER (iSCSI Extensions for RDMA). Two different
> pieces of software are necessary to make networked storage possible:
> initiator software and target software. As far as I know there exist
> three different SCSI target implementations for Linux:
> - The iSCSI Enterprise Target Daemon (IETD,
> http://iscsitarget.sourceforge.net/);
> - The Linux SCSI Target Framework (STGT, http://stgt.berlios.de/);
> - The Generic SCSI Target Middle Level for Linux project (SCST,
> http://scst.sourceforge.net/).
> Since I was wondering which SCSI target software would be best suited
> for an InfiniBand network, I started evaluating the STGT and SCST SCSI
> target implementations. Apparently the performance difference between
> STGT and SCST is small on 100 Mbit/s and 1 Gbit/s Ethernet networks,
> but the SCST target software outperforms the STGT software on an
> InfiniBand network. See also the following thread for the details:
> http://sourceforge.net/mailarchive/forum.php?thread_name=e2e108260801170127w2937b2afg9bef324efa945e43%40mail.gmail.com&forum_name=scst-devel.
>
>   
Sorry for the late response (but better late than never).

One may claim that STGT should have lower performance than SCST because
its data path is from userspace. However, your results show that for
non-IB transports, they both show the same numbers. Furthermore, with IB
there shouldn't be any additional difference between the 2 targets
because data transfer from userspace is as efficient as data transfer
from kernel space.

The only explanation that I see is that fine tuning for iSCSI & iSER is
required. As was already mentioned in this thread, with SDR you can get
~900 MB/sec with iSER (on STGT).

Erez
