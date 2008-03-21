Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYCUSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYCUSdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756050AbYCUSdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:33:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:64282 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYCUSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=jqgUopCkOJlR1Uo+D9r4KvG4HKOjj30NuS5+PuBboeUUqOkDnihOGG+nTVTj56wszQOI06l1Mt2tkdst6R7/clJ1b4TeMl67wv3AD6gjlG+jyoiN+p5p807U+foOP1Q8HhenwsKVGLwZvJDWeOZLPmO0JVx8Q3aC5sIQNn6Nk80=
Message-ID: <47E3FF30.3090300@gmail.com>
Date: Fri, 21 Mar 2008 13:32:16 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
References: <200803201518.32109.hpj@urpla.net> <20080320214830.6d39876d.akpm@linux-foundation.org>
In-Reply-To: <20080320214830.6d39876d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide)
> (regression?)
> 
> On Thu, 20 Mar 2008 15:18:31 +0100 Hans-Peter Jansen <hpj@urpla.net> wrote:
> 
>> Hi,
>>
>> since I upgraded to 2.6.24.3 on one of my production systems, I see 
>> regular device resets like these:

Hans,

What kernel were you using before you updated to that kernel?

>>
>> Mar 20 14:33:03 lisa5 kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> Mar 20 14:33:03 lisa5 kernel: ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Mar 20 14:33:03 lisa5 kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Mar 20 14:33:03 lisa5 kernel: ata2.00: status: { DRDY }
>> Mar 20 14:33:03 lisa5 kernel: ata2: hard resetting link
>> Mar 20 14:33:05 lisa5 kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> Mar 20 14:33:05 lisa5 kernel: ata2.00: configured for UDMA/100
>> Mar 20 14:33:05 lisa5 kernel: ata2: EH complete
>> Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
>> Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Write Protect is off
>> Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> Mar 20 14:33:05 lisa5 kernel: sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>> Mar 20 14:36:11 lisa5 kernel: ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> Mar 20 14:36:11 lisa5 kernel: ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>> Mar 20 14:36:11 lisa5 kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Mar 20 14:36:11 lisa5 kernel: ata3.00: status: { DRDY }
>> Mar 20 14:36:11 lisa5 kernel: ata3: hard resetting link
>> Mar 20 14:36:13 lisa5 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
>> Mar 20 14:36:13 lisa5 kernel: ata3.00: configured for UDMA/100
>> Mar 20 14:36:13 lisa5 kernel: ata3: EH complete
>> Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
>> Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Write Protect is off
>> Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>> Mar 20 14:36:13 lisa5 kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>
>> Should I be worried? smartd doesn't show anything suspicious on those.
>>

Andrew,

I don't think it is a recent regression, I have seen it happening for a while on 
my machine, I don't think it is causing any crashes but I am getting unexplained 
events about 1x per month that appear to deadlock a number of things (machine is 
up, but top won't run and vmstat actually gets a FP exception on the second 
sample, and a number of other things have issues until reboot).

I have 4 identical disks, 2 on a sata_sil and 2 on another controller, the ones 
on the sil controller have this behavior, I have seen it in 2.6.23.1, 
FC7-2.6.23.15-80 and FC7-2.6.22.9-91.   My sil is a 4-port 3114 PCI card, and my 
disks are 500GB Western Digital disks.  I have a fairly long run with 20-30 
events on the 2 disks on the sata_sil and no events on the identical non-sil 
disks that had previously been getting resets (when on the sil controller), and 
since they are under software raid5 all 4 disks should have very very similar IO 
loads.

                           Roger

