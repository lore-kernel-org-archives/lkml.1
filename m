Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZDFTFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZDFTFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbZDFTFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:05:31 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:53351 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZDFTFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:05:30 -0400
Message-ID: <49DA5274.5030708@wpkg.org>
Date: Mon, 06 Apr 2009 21:05:24 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Bart Van Assche <bart.vanassche@gmail.com>
CC: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>	 <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>	 <49D9D9A0.40106@wpkg.org> <e2e108260904061201y1e73d1chca088e6f20b1ddf6@mail.gmail.com>
In-Reply-To: <e2e108260904061201y1e73d1chca088e6f20b1ddf6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche schrieb:
> On Mon, Apr 6, 2009 at 12:29 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>> The target is running Debian Lenny 64bit userspace on an Intel Celeron
>> 2.93GHz CPU, 2 GB RAM.
>>
>> Initiator is running Debian Etch 64 bit userspace, open-iscsi 2.0-869, Intel
>> Xeon 3050/2.13GHz, 8 GB RAM.
>>
>>
>> Each test was repeated 6 times, "sync" was made and caches were dropped on
>> both sides before each test was started.
>>
>> dd parameters were like below, so 6.6 GB of data was read each time:
>>
>> dd if=/dev/sdag of=/dev/null bs=64k count=100000
>>
>>
>> Data was read from two block devices:
>> - /dev/md0, which is RAID-1 on two ST31500341AS 1.5 TB drives
>> - encrypted dm-crypt device which is on top of /dev/md0
>>
>> Encrypted device was created with the following additional options passed to
>> cryptsetup
>> (it provides the most performance on systems where CPU is a bottleneck, but
>> with decreased
>> security when compared to default options):
>>
>> -c aes-ecb-plain -s 128
>>
>>
>> Generally, CPU on the target was a bottleneck, so I also tested the load on
>> target.
>>
>>
>> md0, crypt columns - averages from dd
>> us, sy, id, wa - averages from vmstat
>>
>>
>> 1. Disk speeds on the target
>>
>> Raw performance: 102.17 MB/s
>> Raw performance (encrypted):  50.21 MB/s
>>
>>
>> 2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s
>>
>>                          md0   us  sy  id  wa  | crypt   us  sy  id  wa
>>  STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 16% 19%
>> SCST (debug + no patches) 43.75   0% 26% 30% 44% | 42.05    0% 84%  1% 15%
>> SCST (fullperf + patches) 45.18   0% 25% 33% 42% | 44.12    0% 81%  2% 17%
> 
> Hello Tomasz,
> 
> How is it possible that for this test the read performance through
> STGT (50.63 MB/s) was higher than the read performance on the target
> (50.21 MB/s) ? Are you sure that all read buffers were flushed before
> this test was started ?

You're looking at wrong columns:

      md0     crypt
STGT 50.63   32.52
RAW  102.17  50.21

-- 
Tomasz Chmielewski
http://wpkg.org

