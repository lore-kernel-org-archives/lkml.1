Return-Path: <linux-kernel-owner+w=401wt.eu-S1752974AbZCNJfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbZCNJfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 05:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZCNJet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 05:34:49 -0400
Received: from smtp03.mail.tnz.yahoo.co.jp ([203.216.246.66]:47880 "HELO
	smtp03.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751649AbZCNJes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 05:34:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Cc:References:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=HsTnWbJcSW8nVuP+/HQmGwYTGpCBfCf9/AneePxoDc6Q7kB7kykLLpbh/0qUOQwW2gLwidDd6zorNCxlSQpxSu/rGbxyyNoWjIy7/9AhzFrZ9IvClXvuya3+hcPpm8Xc  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <078E30E4A81049A2847E24B3CF39BB5C@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Robert Hancock" <hancockrwd@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Jim Paris" <jim@jtan.com>, "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Mark Lord" <liml@rtr.ca>
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp><49BA7172.80908@gmail.com><A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600><49BB1341.2020203@gmail.com> <20090314084827.2f2b05c2@lxorguk.ukuu.org.uk>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Date: Sat, 14 Mar 2009 18:34:23 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> [attribution stolen:]
>> ata_piix should definitely attach to 8086/7111 regardless of the 
>> subsystem IDs. I can't really explain why it's not. You should at least 
>> be seeing a message about the ata_piix version, if not then somehow the 
>> driver probe function isn't even being called..
>
> Because on at least some kernels
> hda=noprobe ... etc
> does not stop the old IDE layer grabbing the PCI device and continuing to 
> claim ownership (which means ATA cannot attach to it).

That could be part of the explanation.  dmesg did include the usual 
statements about PIIX4 not being 100% native and irqs would be probed later 
(though of course they weren't probed later).

> Arguably this is correct behaviour as the IDE layer was asked to ignore 
> the devices *NOT* to ignore the controller.

That doesn't explain why ide0=noprobe ide1=noprobe hda=none hdb=none 
hdc=none hdd=none still didn't stop the old IDE layer from grabbing 
something.  ATA didn't report whether there was something it couldn't grab 
onto, all it did was report loading and that was the end of it.


Alan Cox also wrote:
> [Norman Diamond:]
>> I think the PIIX4 devices of VMware server are well known.  Besides 
>> vendor 8086 and device 7111, VMware's subsystem is coded into LIBATA's 
>> PIIX driver.
>
> That is a known working case so its something about your setup or build.

I doubt it.  I think your other message explained part of the reason, though 
something is still missing.

> You might want to try building with CONFIG_IDE=n and CONFIG_ATA + ATA_PIIX 
> + AHCI = y to double check your config.

CONFIG_ATA + ATA_PIIX + AHCI  were always y all along.  An experiment 
changing old IDE from y to m got PIIX4 working, but I'm still nervous about 
lots of cases where I don't have machines with other old IDE chipsets to 
test. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
