Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZKTLbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZKTLbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZKTLbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:31:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35955 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbZKTLbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:31:39 -0500
Message-ID: <4B067E1A.7000102@garzik.org>
Date: Fri, 20 Nov 2009 06:31:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Zeno Davatz <zdavatz@gmail.com>
CC: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [Bug #14622] Second IDE device not found
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>	 <xXQGFmujPl.A.n7F.4SdALB@chimera>	 <20091119.120550.183823935.davem@davemloft.net>	 <40a4ed590911192359o563b104fo562f325ad9f5358e@mail.gmail.com>	 <4B065648.6040609@garzik.org> <40a4ed590911200129p6f0d048dqef10df2b311d4744@mail.gmail.com>
In-Reply-To: <40a4ed590911200129p6f0d048dqef10df2b311d4744@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2009 04:29 AM, Zeno Davatz wrote:
> On Fri, Nov 20, 2009 at 9:41 AM, Jeff Garzik<jeff@garzik.org>  wrote:
>> On 11/20/2009 02:59 AM, Zeno Davatz wrote:
>>>
>>> On Thu, Nov 19, 2009 at 9:05 PM, David Miller<davem@davemloft.net>    wrote:
>>>>
>>>> From: "Rafael J. Wysocki"<rjw@sisk.pl>
>>>> Date: Mon, 16 Nov 2009 23:37:47 +0100 (CET)
>>>>
>>>>> This message has been generated automatically as a part of a report
>>>>> of recent regressions.
>>>>>
>>>>> The following bug entry is on the current list of known regressions
>>>>> from 2.6.31.  Please verify if it still should be listed and let me know
>>>>> (either way).
>>>>>
>>>>>
>>>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=14622
>>>>> Subject               : Second IDE device not found
>>>>> Submitter     : Zeno Davatz<zdavatz@gmail.com>
>>>>> Date          : 2009-11-11 17:31 (6 days old)
>>>>> References    : http://marc.info/?l=linux-kernel&m=125796105822353&w=4
>>>>
>>>> We're going to need more information to diagnose this.
>>>>
>>>> And linux-ide should have been at least CC:'d from the very
>>>> beginning.
>>>>
>>>>   From what I can discern the problem is introduced somewhere between
>>>> 2.6.27 and 2.6.31, you have a Serverworks CSB5 and primarily the issue
>>>> is that attaching or detaching your CD-ROM driver influences whether
>>>> both of your disks are properly detected.  Correct?
>>>>
>>>> You seem to have played around with using the IDE layer vs. the
>>>> ATA layer.  Can you see any difference in behavior if you try
>>>> using just the IDE layer vs. just the ATA layer with the 2.6.31
>>>> kernel?
>>>
>>> Please see:
>>>
>>> http://www.flickr.com/photos/zrr/4118682747/
>>>
>>> and
>>>
>>> http://www.flickr.com/photos/zrr/4119453092/
>>
>> Unfortunately, both of these photos only show that MD (block major 9) device
>> could not be found for root.
>>
>> For either ATA or IDE, we would need to see full dmesg somehow -- perhaps
>> capturing serial console output?  (Documentation/serial-console.txt)
>
> Ok, I appended
>
> console=ttyS1,9600 console=tty0
>
> to the kernel command line at lilo after choosing the kernel image and
> I get a ton of output. But how to I save the output to a file?

I use minicom and a null modem serial cable.  One of minicom's commands 
will capture everything sent to the serial port, to a file.  Other 
options are available.  Googling for "linux serial console" found 
several useful starting-point links.

The basic idea is to sent console output to a serial port, and then have 
some method of reading and capturing the serial port's data.

Another alternative is netconsole (google for "linux netconsole"), which 
permits output over the network.


>>> I makes no difference if I choose ATA or only IDE.
>>>
>>> I am also attaching you my Kernel .config
>>>
>>> I could also test with 2.6.32-rc8 (torvalds-git)
>>>
>>> I suggest you send me two .config that I can both test with 2.6.31.6
>>
>> I bet libata fails because CONFIG_BLK_DEV_SD is not enabled.  Probably want
>> to enable CONFIG_BLK_DEV_SR too, for libata CD-ROM support.  I would be
>> interested to see your failing ATA config, with IDE disabled.
>
> I enabled CONFIG_BLK_DEV_SR. Do you want above test with or without
>
> CONFIG_BLK_DEV_SVWKS (OSB4/CSB5) enabled?

Well, this goes back to David's basic request:  IDE-only or ATA-only.

You really, really, really should not to enable both at the same time.

If you are choosing ATA-only (libata), then you should disable 
CONFIG_IDE and everything associated with CONFIG_IDE, including 
CONFIG_BLK_DEV_SVWKS.

libata will want something like
CONFIG_ATA
CONFIG_ATA_VERBOSE_ERROR	<-- optional, but helpful
CONFIG_PATA_SERVERWORKS

CONFIG_SCSI
CONFIG_SCSI_LOGGING		<-- ditto
CONFIG_SCSI_CONSTANTS		<-- ditto
CONFIG_BLK_DEV_SD
CONFIG_BLK_DEV_SR		<-- required only for CD-ROM support

Regards,

	Jeff




