Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbZC3SeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbZC3SeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZC3SeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:34:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56433 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbZC3SeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:34:09 -0400
Message-ID: <49D11096.3070804@vlnb.net>
Date: Mon, 30 Mar 2009 22:33:58 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: scst-devel <scst-devel@lists.sourceforge.net>,
       iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, stgt@vger.kernel.org
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
References: <49D10256.8030307@vlnb.net> <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
In-Reply-To: <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX180CNsv3YdCRCo1xSfA2gWPPHbEvaimGbBb61I
 7Z6m87B6/7VILbJuAw9tP3eal6WbcZDMUS5T/z1ZKX846W3X0X
 0dHvmwO4aeMjfSj2m/q+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche, on 03/30/2009 10:06 PM wrote:
> On Mon, Mar 30, 2009 at 7:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> As part of 1.0.1 release preparations I made some performance tests to make
>> sure there are no performance regressions in SCST overall and iSCSI-SCST
>> particularly. Results were quite interesting, so I decided to publish them
>> together with the corresponding numbers for IET and STGT iSCSI targets. This
>> isn't a real performance comparison, it includes only few chosen tests,
>> because I don't have time for a complete comparison. But I hope somebody
>> will take up what I did and make it complete.
>>
>> Setup:
>>
>> Target: HT 2.4GHz Xeon, x86_32, 2GB of memory limited to 256MB by kernel
>> command line to have less test data footprint, 75GB 15K RPM SCSI disk as
>> backstorage, dual port 1Gbps E1000 Intel network card, 2.6.29 kernel.
>>
>> Initiator: 1.7GHz Xeon, x86_32, 1GB of memory limited to 256MB by kernel
>> command line to have less test data footprint, dual port 1Gbps E1000 Intel
>> network card, 2.6.27 kernel, open-iscsi 2.0-870-rc3.
>>
>> The target exported a 5GB file on XFS for FILEIO and 5GB partition for
>> BLOCKIO.
>>
>> All the tests were ran 3 times and average written. All the values are in
>> MB/s. The tests were ran with CFQ and deadline IO schedulers on the target.
>> All other parameters on both target and initiator were default.
> 
> These are indeed interesting results. There are some aspects of the
> test setup I do not understand however:
> * All tests have been run with buffered I/O instead of direct I/O
> (iflag=direct / oflag=direct). My experience is that the results of
> tests with direct I/O are easier to reproduce (less variation between
> runs). So I have been wondering why the tests have been run with
> buffered I/O instead ?

Real applications use buffered I/O, hence it should be used in tests. It 
  evaluates all the storage stack on both initiator and target as a 
whole. The results are very reproducible, variation is about 10%.

> * It is well known that having more memory in the target system
> improves performance because of read and write caching. What did you
> want to demonstrate by limiting the memory of the target system ?

If I had full 2GB on the target, I would have to spend on the 
measurements 10 times more time, since the data footprint should be at 
least 4x of the cache size. For sequential read/writes 256MB and 2GB of 
the cache are the same.

Where it did matter (io_trash) I increased memory size to full 2GB.

> * Which SCST options were enabled on the target ? Was e.g. the
> NV_CACHE option enabled ?

Defaults, i.e. yes, enabled. But it didn't matter, since all the 
filesystems where mounted on the initiator without data barriers enabled.

Thanks,
Vlad

P.S. Please don't drop CC.
