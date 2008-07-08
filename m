Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYGHKd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYGHKd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 06:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYGHKdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 06:33:46 -0400
Received: from chello212186124096.11.vie.surfer.at ([212.186.124.96]:45766
	"EHLO wiesinger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYGHKdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:33:45 -0400
Date: Tue, 8 Jul 2008 12:33:11 +0200 (CEST)
From: Gerhard Wiesinger <lists@wiesinger.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan>
Message-ID: <alpine.LFD.1.10.0807081232350.32659@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.DEB.1.10.0807080433550.17980@p34.internal.lan>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-MailScanner-Information-wiesinger.com: Please contact the ISP for more information
X-MailScanner-wiesinger.com: Found to be clean
X-MailScanner-SpamCheck-wiesinger.com: not spam, SpamAssassin (score=-4.399,
	required 4.5, autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-MailScanner-From: lists@wiesinger.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Justin Piszcz wrote:

>
>
> On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:
>
>> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>> 
>>> Hi Gerhard,
>>> 
>>> It /could/ be the port itself if you have changed the cable and disk..
>>> 
>> 
>> Yes, but it is very unlikely. I have written TB of data there without any 
>> problems. Anyway this is my 3rd exchanged SAMSUNG disk ...
>> 
>> 
>>> Have you tried loading the disk with dd and seeing if you can reproduce 
>>> the problem? You are getting the same error I get generally, I can 
>>> recommend turning OFF NCQ first and see if the problem goes away.
>>> 
>>> # Define DISKS.
>>> cd /sys/block
>>> DISKS=$(/bin/ls -1d sd[a-z])
>>> 
>>> # Disable NCQ on all disks.
>>> echo "Disabling NCQ on all disks..."
>>> for i in $DISKS
>>> do
>>>  echo "Disabling NCQ on $i"
>>>  echo 1 > /sys/block/"$i"/device/queue_depth
>>> done
>>> 
>> 
>> I tried to disable NCQ on all disks and tried to rebuild the raid, but it 
>> still failed to rebuild with the same error message.
>> 
>> I also tried the nolapic kernel parameter without success.
>> 
>> /dev/sda:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
>> Always       -       0
>> /dev/sdb:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
>> Always       -       0
>> /dev/sdc:  5 Reallocated_Sector_Ct   0x0033   091   091   010    Pre-fail 
>> Always       -       413
>> /dev/sdd:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
>> Always       -       0
>> /dev/sde:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
>> Always       -       0
>> /dev/sdf:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
>> Always       -       0
>> 
>> The only thing is that the Reallocated_Sector_Ct is still >0 on /dev/sdc 
>> (keep in mind this is my 3rd new Samsung disk on /dev/sdc and I had up to 
>> 3000 Reallocated_Sector_Ct on previous disks in < 1 day !!!).
>> 
>> Should I replace the disk a fourth time?
>> 
>> When you search in google you find a lot of threads with the timeout 
>> problem. Might this be a software issue?
>> 
>> Any ideas?
>
> Please run:
>
> smartctl -t short /dev/sdc
> sleep 300
> smartctl -t long /dev/sdc
>
> Wait 2-3 hours or more and:
>
> smartctl -a /dev/sdc


I'm changing the disk one more time ...

Ciao,
Gerhard

--
http://www.wiesinger.com/

