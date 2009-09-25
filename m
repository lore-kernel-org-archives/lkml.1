Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbZIYELn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbZIYELn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZIYELl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:11:41 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35216 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZIYELk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:11:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BNvTeAZ5aS6VhmsmIdqlwUvFpU4aaUSd8KK57qdeCVg3g752FFEWae0xx+NU02GmWQ
         GTyybnfNOkLdzMHcMIeWo1hElwsrQAjRI2YtUn/kPYz9qKUft+Np8ty0KvUCtLzoWfh/
         b4ccTKYveaA66oAnBXFp1DTn9yAEnTOdF7NTs=
Message-ID: <4ABC42F9.3010403@gmail.com>
Date: Fri, 25 Sep 2009 13:11:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Berthold Gunreben <b.gunreben@web.de>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Niel Lambrechts <niel.lambrechts@gmail.com>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it> <cnTWo-7bV-25@gated-at.bofh.it> <4A446998.4070508@gmail.com> <200909182226.39660.b.gunreben@web.de>
In-Reply-To: <200909182226.39660.b.gunreben@web.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Berthold.

Berthold Gunreben wrote:
> I am not quite sure if I am at the right place here, however, I get very
> similar problems with a totally different setup. What I do is the following:
> 
> I added a fourth disk to a software raid5 array and did setup the raid
> completely from scratch (the same disks have been running for about
> 1.5 years without any problems before, the difference is that previously
> one of the disks was setup as hot spare).
> 
> After the software raid was in sync, I started to copy my data back to
> the raid, and after a  less than 5 minutes time, one of the disks failed
> (from /var/log/warn):
> 
> Sep 18 22:04:02 Bacchus kernel: ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x10000 action 0xe frozen
> Sep 18 22:04:02 Bacchus kernel: ata3.00: irq_stat 0x00400000, PHY RDY changed
> Sep 18 22:04:02 Bacchus kernel: ata3: SError: { PHYRdyChg }
> Sep 18 22:04:02 Bacchus kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Sep 18 22:04:02 Bacchus kernel:          res 40/00:0c:3f:6c:d5/00:00:15:00:00/40 Emask 0x10 (ATA bus error)
> Sep 18 22:04:02 Bacchus kernel: ata3.00: status: { DRDY }

The disk is most likely losing power briefly.  After boot, run
"smartctl -a" on the device and record the output.  After triggering
the problem, do it again.  See if Start_Stop_Count, Power_Cycle_Count
or Power-Off_Retract_Count has increased.  If so, take out your PSU,
bury it half-deep in your backyard, apply some gasoline, light it up
and enjoy the sight of perishing evil with a can of beer.

Thanks.

-- 
tejun
