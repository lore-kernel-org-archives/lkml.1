Return-Path: <linux-kernel-owner+w=401wt.eu-S1762384AbZDBRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762384AbZDBRQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbZDBRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:16:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZDBRQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:16:27 -0400
Message-ID: <49D4F2E1.7000507@vlnb.net>
Date: Thu, 02 Apr 2009 21:16:17 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: scst-devel <scst-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
References: <49D10256.8030307@vlnb.net> <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
In-Reply-To: <e2e108260904011314h1e0cf5c5wcdf210eee24d40d8@mail.gmail.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19XI8unkpqG/+uPG6JyZegN24Gc7/lcltkiI7R
 IleLW9Qx6apBFU2s+oL1wY8VEavGoVOPEnre7HtLXXzeyVRpZn
 5czDS3fZUaKW7p8DQDS7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche, on 04/02/2009 12:14 AM wrote:
> On Mon, Mar 30, 2009 at 7:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> ==================================================================
>> I. SEQUENTIAL ACCESS OVER SINGLE LINE
>>
>> 1. # dd if=/dev/sdX of=/dev/null bs=512K count=2000
>>
>>                        ISCSI-SCST      IET             STGT
>> NULLIO:                 106             105             103
>> FILEIO/CFQ:             82              57              55
>> FILEIO/deadline         69              69              67
>> BLOCKIO/CFQ             81              28              -
>> BLOCKIO/deadline        80              66              -
> 
> I have repeated some of these performance tests for iSCSI over IPoIB
> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). The results
> for the buffered I/O test with a block size of 512K (initiator)
> against a file of 1GB residing on a tmpfs filesystem on the target are
> as follows:
> 
> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
> 
> And for a block size of 4 KB:
> 
> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.

Do you have any thoughts why writes are so bad? It shouldn't be so..

> Or: depending on the test scenario, SCST transfers data between 2% and
> 30% faster via the iSCSI protocol over this network.
> 
> Something that is not relevant for this comparison, but interesting to
> know: with the SRP implementation in SCST the maximal read throughput
> is 1290 MB/s on the same setup.

This can be well explained. The limiting factor for iSCSI is that 
iSCSI/TCP processing overloads a single CPU core. You can prove that on 
vmstat output during the test. Sum of user and sys time should be about 
100/(number of CPUs) or higher. SRP has a lot more CPU effective, hence 
better has throughput.

If you try to test with 2 or more parallel IO streams, you should have 
the correspondingly increased aggregate throughput up to the moment you 
hit your memory copy bandwidth.

Thanks,
Vlad


> Bart.
> 
> ------------------------------------------------------------------------------
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

