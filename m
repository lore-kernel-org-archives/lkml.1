Return-Path: <linux-kernel-owner+w=401wt.eu-S965709AbXBHJXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965709AbXBHJXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965712AbXBHJXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:23:52 -0500
Received: from web52908.mail.yahoo.com ([206.190.49.18]:41551 "HELO
	web52908.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965709AbXBHJXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:23:51 -0500
Message-ID: <20070208092350.86580.qmail@web52908.mail.yahoo.com>
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=zZdmUyggLH5RcqOKLSgXn4QQJfyy3ME9xoKjeHiuI3Yf/XsZr4kJxoZhMuffXnCGJtLarvqDgnBlIroQiwTooGrMQy7jVeuXv9teWHGKVaYjK8IbbDzLvInChlsujtbS3NVkv1gEU4fXkAPPaXiNKZuSP2UIKyv15coLsTKEoYQ=;
X-YMail-OSG: MIAVlaUVM1n4RI2k1U8YTMKPBf0BXm2qWApmufa7IoHi8aV.pvt_LAmGj_.D3KOxCZ6EX0RIDripNF9NV9WbG0RmzEvl9ZGxan4Qpfkmnbz3OVK1PqJ8oU5ZIQ.E.jzTQIaGgE.z1A9wrrZx1jJIpubW7VPGfR.RkLFKYMybmrypfqHSAB4Ni.UEu6YQ
Date: Thu, 8 Feb 2007 01:23:50 -0800 (PST)
From: Simon White <sidplay2@yahoo.com>
Subject: Re: Multiple virtual bus instances
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>> I've been working through trying to
>> create a virtual bus.

>How does this differ from a "real" bus?

None, just there wasn't a real hardware
bus (O'Reilly's Linux Device Drivers 3
chapter 14 page 377).

>> I've successfuly made it work for a
>> single instance but wanted to confirm
>> how to create multiple instances of
>> the virtual bus.

> Why would you need that?

We are trying to get the device drivers
for the Catweasel MK3/4 cards ready for
submission into mainline after repeated
requests.  However the hardware on it
differs greatly in nature so we have
serveral fragmented drivers for each
specific bit (written by different
parties).  Naturally they don't play
well together.

It was thought creating a bus for each
pci cmk3/4 card, where the bus deals
with bank switching, etc.  This allows
individual drivers to use newly
exported devices fixing the issues we
have now.  It would also help being
this way for debugging, i.e. other
parties code can be easily removed.

>> I believe to do this you have only
>> one instance of your new bus_type
>> registered but register multiple
>> instances of struct device for it.
>> I just wanted to confirm that was
>> correct.

>That would create multiple devices on
>the same bus.  Is that what you need
>to do?

>From your description no.  One thing I
was however trying to avoid was lots of
buses showing under /sys/bus.

> Note that you can have multiple trees
> of devices, all with the same
> bus_type, yet not joined together in
> any other way.  Odds are, you probably
> want to do that, right?

Yes.  If you still think that is correct
given the above are there examples to
follow?

Regards,
Simon


 
____________________________________________________________________________________
Expecting? Get great news right away with email Auto-Check. 
Try the Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/newmail_tools.html 
