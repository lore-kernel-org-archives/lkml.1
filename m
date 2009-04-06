Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZDFS2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZDFS2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZDFS2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:28:03 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:44778 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZDFS2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:28:00 -0400
Message-ID: <49DA49AA.1060106@wpkg.org>
Date: Mon, 06 Apr 2009 20:27:54 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com> <49D9D9A0.40106@wpkg.org> <49DA33EF.3020700@vlnb.net>
In-Reply-To: <49DA33EF.3020700@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin schrieb:

>> Encrypted device was created with the following additional options 
>> passed to cryptsetup
>> (it provides the most performance on systems where CPU is a 
>> bottleneck, but with decreased
>> security when compared to default options):
>>
>> -c aes-ecb-plain -s 128
>>
>>
>> Generally, CPU on the target was a bottleneck, so I also tested the 
>> load on target.
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
>>                            md0   us  sy  id  wa  | crypt   us  sy  id  
>> wa  STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 
>> 16% 19%
>> SCST (debug + no patches) 43.75   0% 26% 30% 44% | 42.05    0% 84%  1% 
>> 15%
>> SCST (fullperf + patches) 45.18   0% 25% 33% 42% | 44.12    0% 81%  2% 
>> 17%
>>
>>
>> 3. Read-ahead on the initiator: 16384; md0, crypt - MB/s
>>
>>                            md0   us  sy  id  wa  | crypt   us  sy  id  
>> wa  STGT                      56.43   3% 55%  2% 40% | 46.90    3% 
>> 90%  3%  4%
>> SCST (debug + no patches) 73.85   0% 58%  1% 41% | 42.70    0% 85%  0% 
>> 15%
>> SCST (fullperf + patches) 76.27   0% 63%  1% 36% | 42.52    0% 85%  0% 
>> 15%
> 
> Good! You proved that:
> 
> 1. SCST is capable to work much better than STGT: 35% for md and 37% for 
> crypt considering maximum values.
> 
> 2. Default read-ahead size isn't appropriate for remote data access 
> cases and should be increased. I slowly have been discussing it in past 
> few months with Wu Fengguang, the read-ahead maintainer.

Note that crypt performance for SCST was worse than that of STGT for 
large read-ahead values.
Also, SCST performance on crypt device was more or less the same with 
256 and 16384 readahead values. I wonder why performance didn't increase 
here while increasing readahead values? Could anyone recheck if it's the 
same on some other system?


> Which IO scheduler on the target did you use? I guess, deadline? If so, 
> you should try with CFQ as well.

I used CFQ.


-- 
Tomasz Chmielewski
http://wpkg.org
