Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbYHEXDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbYHEXDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYHEXCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:02:41 -0400
Received: from nebensachen.de ([195.34.83.29]:49294 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYHEXCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:02:39 -0400
X-Hashcash: 1:20:080805:pavel@suse.cz::UaXhNWpmfzWf0u9V:00000Inw
X-Hashcash: 1:20:080805:tytso@mit.edu::b2RRYA/tLmKmNPSP:00000z8R
X-Hashcash: 1:20:080805:hancockr@shaw.ca::pS+0jjwCE56Wqs9X:02waK
X-Hashcash: 1:20:080805:alan@lxorguk.ukuu.org.uk::MFusPvJfms4u6TaT:000000000000000000000000000000000000066Oi
X-Hashcash: 1:20:080805:gombasg@sztaki.hu::522tW8ncxTlDNOWX:000000000000000000000000000000000000000000001J1F
X-Hashcash: 1:20:080805:htejun@gmail.com::Hg8Ti3XAnlqORfbw:03grj
X-Hashcash: 1:20:080805:jeff@garzik.org::2GCrvThYpmMIdRST:0028Eq
X-Hashcash: 1:20:080805:bzolnier@gmail.com::aWmtqvsP/il6tijp:00000000000000000000000000000000000000000003hhb
X-Hashcash: 1:20:080805:james.bottomley@hansenpartnership.com::bDl1wXiJLF5hnEWr:0000000000000000000000001cRS
X-Hashcash: 1:20:080805:linux-ide@vger.kernel.org::GBaoNP0DL26Ypt3A:0000000000000000000000000000000000003p+0
X-Hashcash: 1:20:080805:linux-kernel@vger.kernel.org::8vHAsHEhFcj0lirm:000000000000000000000000000000000DC1P
From: Elias Oltmanns <eo@nebensachen.de>
To: Pavel Machek <pavel@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Robert Hancock <hancockr@shaw.ca>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Gabor Gombas <gombasg@sztaki.hu>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <fa.nx0yFPJm+aNXPHgykUrOzZXvvIs@ifi.uio.no>
	<fa.NfEr7Ik6e8oextyWICW/jR5emeE@ifi.uio.no>
	<fa.zGvATZImeUo0tHJe4hzlk5+mTiM@ifi.uio.no>
	<fa.SRVleMItV5QEF7/tgCjSHz0ScJA@ifi.uio.no>
	<fa.YKbhgq8XUxH/Qg1ArE+73YsDlpE@ifi.uio.no> <4897D16F.3000504@shaw.ca>
	<20080805131417.GC8569@mit.edu> <20080805195912.GE7939@elf.ucw.cz>
Date: Wed, 06 Aug 2008 00:57:09 +0200
Message-ID: <871w13xe7u.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending because gmane cut off the To: header in Pavel's email, sorry.]

Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
[...]
>> So there's a reason why the anti-shock protection is set at a rather

[+]
>> sensitive level...    
>> 
>> The real right answer though is to buy one of the laptop drives (such
>> as the Seagate Momentus 7200.2 or 7200.3) which has the anti-shock
>> detection built directly into the hard drive.  That way you don't have
>> to have a daemon that sits in the OS waking up the CPU some 20 to 30
>> times a second and burning up your battery even when the laptop is
>> idle.
>
> Hmm, when the laptop is idle, "right thing" is to spin the disk down,
> and at that point you no longer need to poll the accelerometer...

Not quite, I'm afraid. Even if the disk isn't spinning, we still have to
make sure that it won't spin up in a precarious situation. Of course, if
it wasn't user space but some kernel routine that consults the
accelerometer and decides when to stop I/O, then we could indeed stop
querying the accelerometer while the disk is in standby mode and delay a
subsequent spin up for the time required to gather the necessary
accelerometer data. However, as I have explained before, it is not quite
trivial to implement all this in kernel space and I'd like to get head
unloading merged first.

Regards,

Elias
