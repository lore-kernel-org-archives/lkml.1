Return-Path: <linux-kernel-owner+w=401wt.eu-S932347AbZDQSL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbZDQSL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZDQSLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:11:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbZDQSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:11:02 -0400
Message-ID: <49E8C63D.8090901@vlnb.net>
Date: Fri, 17 Apr 2009 22:11:09 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: scst-devel <scst-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
References: <49D10256.8030307@vlnb.net>	<e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>	<49D4F2E1.7000507@vlnb.net> <e2e108260904040104u37953ef7x74b8713dfcf3166a@mail.gmail.com>
In-Reply-To: <e2e108260904040104u37953ef7x74b8713dfcf3166a@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+igX3ZGkAvVS2JveWvUDZIfpWJCrAqKxeByWt
 xAy8uKOI8l+DDIh2tpKl6oczgBcLGf7I5GLQDbHq0ALMRk9vwj
 SKJFU6W3eaIZ3S4u61WDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche, on 04/04/2009 12:04 PM wrote:
> On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Bart Van Assche, on 04/02/2009 12:14 AM wrote:
>>> I have repeated some of these performance tests for iSCSI over IPoIB
>>> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
>>> for the buffered I/O test with a block size of 512K (initiator)
>>> against a file of 1GB residing on a tmpfs filesystem on the target are
>>> as follows:
>>>
>>> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
>>> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
>>>
>>> And for a block size of 4 KB:
>>>
>>> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
>>> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
>> Do you have any thoughts why writes are so bad? It shouldn't be so..
> 
> By this time I have run the following variation of the 4 KB write test:
> * Target: iSCSI-SCST was exporting a 1 GB file residing on a tmpfs filesystem.
> * Initiator: two processes were writing 4 KB blocks as follows:
> dd if=/dev/zero of=/dev/sdb bs=4K seek=0 count=131072 oflag=sync &
> dd if=/dev/zero of=/dev/sdb bs=4K seek=131072 count=131072 oflag=sync &
> 
> Results:
> * Each dd process on the initiator was writing at a speed of 37.8
> MB/s, or a combined writing speed of 75.6 MB/s.
> * CPU load on the initiator system during the test: 2.0.
> * According to /proc/interrupts, about 38000 mlx4-comp-0 interrupts
> were triggered per second.
> 
> These results confirm that the initiator system was the bottleneck
> during the 4 KB write test, not the target system.

If so with oflag=direct you should have a performance gain, because you 
will eliminate a data copy.

> Bart.
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

