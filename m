Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbYCUPMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbYCUPMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYCUPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:12:34 -0400
Received: from web34507.mail.mud.yahoo.com ([66.163.178.173]:26947 "HELO
	web34507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756037AbYCUPMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:12:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=TTfLFeqJrrvWPUzyr0VFytCayQXxloRmhD0t5svuioCpTqSYo52bHZb3gvpciwTxIoL3pS0x7jyvBOSsn3EknpxtdU2KBGwqh6V2HOxXlliVgO2BKnqDlT3G9kjqsWiE4zyZ5UREeKBUba7CDmtL3QhRqXKrWVYEKNbbuJcpm+M=;
X-YMail-OSG: SxmqgBgVM1m.yyoSSKU8DCOH6mgnnf7_nhHlz1zUVrY_Z699h84uwNCQBDP4beCeHAE8phBRYV.zUcrf9oa4.twkm5E90wAu2aizGUkqVgm_8w2RMi4-
X-Mailer: YahooMailRC/902.38 YahooMailWebService/0.7.162
Date: Fri, 21 Mar 2008 08:12:32 -0700 (PDT)
From: osb972ww-linuxczmil@yahoo.com
Subject: Re: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <810485.52126.qm@web34507.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun, Alan,

   Everything works when I disable the USB in the bios settings.  I was also able to remove the irqpoll kernel parameter after turning off bios USB. The particularly interesting thing is that the USB mouse still works, as does a USB 2.0 drive I have connected.  The Compact Flash drive at /dev/sda works fine, and the connected SATA drive works as well, though I need to do some testing to see how well these devices are performing. 

Using the irqpoll also made things work except for once.  In that case, I got the same errors, delayed bootup, and missing SATA drive.

Is there a new "hdparm like" tool for working with the new drives/drivers to be able to read/set parameters, run various tests, etc?

This motherboard is an IBT MB899 mini-ITX.

Thanks for the guidance with this!

C. W. Wright




----- Original Message ----
> From: Tejun Heo <htejun@gmail.com>
> To: osb972ww-linuxczmil@yahoo.com
> Cc: linux-kernel@vger.kernel.org; IDE/ATA development list <linux-ide@vger.kernel.org>
> Sent: Friday, March 21, 2008 5:56:10 AM
> Subject: Re: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
> 
> Hello,
> 
> osb972ww-linuxczmil@yahoo.com wrote:
> > setting irqpoll fixed both problems, and there are no "nasty grams"
> > in dmesg now.   The original reason I was trying to use the hdparm -u
> > on /dev/sda was because it was hanging for a few seconds when doing
> > writes to the CFdisk, and in the past that was the kind of thing that
> > hdparm -u would generally fix.
> 
> libata drivers don't need or support hdparm -u settings.
> 
> >  Now with the irqpoll kernel option,
> > the /dev/sdb SATA drive was found, and I can mount it and write to
> > it.  The CFcard /dev/sda is also responding to writes better than
> > before.
> > 
> > Thanks for the suggestion to use irqpoll.    What is the problem
> > within the driver(s) that is requiring irqpoll. ?
> 
> Well, IRQ 18 is taken offline during USB initialization.  The IRQ is
> shared with the SATA controller, so SATA controller doesn't work either.
>  It isn't clear why the IRQ handler is taken offline.  It could be the
> USB controller but can also be the SATA controller.  Does not loading
> usb driver make any difference?
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



