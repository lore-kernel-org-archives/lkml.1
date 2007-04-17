Return-Path: <linux-kernel-owner+w=401wt.eu-S1030241AbXDQVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241AbXDQVlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXDQVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:41:46 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3228 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXDQVlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:41:44 -0400
Message-ID: <46253F14.4020304@rtr.ca>
Date: Tue, 17 Apr 2007 17:41:40 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: emisca <emisca.ml@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
References: <461D4E2C.6000704@redhat.com>	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>	 <461D54AF.3060706@redhat.com> <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com>
In-Reply-To: <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

emisca wrote:
> I can confirm this, I have a Seagate Momentus 5400.3 sata disk, and it
> spins off, respin up and again off when I halt my notebook.
> I had before this disk an IBM/Hitachi one, and it doesn't have this 
> behaviour.
> 
> Take a look at this bug report:
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810
> 
> There are some references and some patches against 2.6.20 kernel. This
> bug is confirmed there.

Yup.  Last I heard, Tejun has fixed this, and queued the code
for 2.6.22 via James B.   But this could be considered a rather
nasty regression in 2.6.21, in that it does seem to cause
significant and unnecessary wear and tear on the drive mechanisms.

I'll patch it locally on my own machines, but what about the tens
of thousands of other Seagate notebook drive owners out there?

Cheers


> 
> Bye
> 
> 2007/4/11, Chuck Ebbert <cebbert@redhat.com>:
>> Jan Engelhardt wrote:
>> > On Apr 11 2007 17:07, Chuck Ebbert wrote:
>> >> When I reboot my notebook, it powers off and powers back on.
>> >> On poweroff a loud snapping noise seems to be coming from the
>> >> hard drive. Today I noticed there is no "shutdown: hda" on
>> >> the console when I reboot. Whne I do a normal poweroff the
>> >> message is displayed and there is no noise. Should the IDE
>> >> code be changed so it always shuts down the drive?
>> >
>> > What sort of notebook? What sort of harddisk?
>>
>> Compaq Presario V2000 series, with a new Seagate ST9120821A
>> 120GB 5400RPM drive.
>>
>> > Is it as loud as `hdparm -y /dev/hdX"?
>>
>> That makes no noise at all except normal drive seek noises.
>>
>> > Try `smartctl -d ata -a /dev/hdX | grep -i unload` too.
>>
>> Hmm.
>>
>> Power_Cycle_Count ... 108
>> Power-Off_Retract_Count ... 90
>>
>> I did a normal poweroff and the retract count went to 91.
>> There is an almost-unnoticeable click when I do it that way.
