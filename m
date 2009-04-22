Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZDVWIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZDVWIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbZDVWHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:07:43 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:49545 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZDVWHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:07:41 -0400
Date: Wed, 22 Apr 2009 19:06:48 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [2.6.30-rc2] usb reset during big file transfer and ext3 error
Message-ID: <20090422220648.GB4066@ime.usp.br>
References: <20090421111015.GA30260@ime.usp.br> <49EE660E.7040907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49EE660E.7040907@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Robert.

On Apr 21 2009, Robert Hancock wrote:
> (ccing linux-usb)

Ok.

> Rogério Brito wrote:
(...)
>> Unfortunately, when I was transferring the contents of 2 DVDs from the
>> main IDE HD to a USB external HD, I got errors from the USB host, the
>> writes on the external HD become failures and the ext3 filesystem there
>> enters into error mode, going read-only.
>>
>> I eventually lose the access to the device (i.e., the /dev/sd??? device
>> isn't there anymore) and I then have to re-run fsck on the given
>> filesystem.
>>
>> This has already happened 2 or 3 times already and I observed that it
>> only occurs when there is high traffic---if I am, say, compiling the
>> kernel on that external HD, I don't see any problems.

I just saw it reoccur once more, this time inducing a stacktrace related
to ext3. :-(

>> Attached is part of the dmesg log that shows the problem. I put the
>> whole dmesg at <http://rb.doesntexist.org/linux/>.
>>
>> As always, if any further information is needed, please let me know.
>
> You're seeing these:
>
> [103051.265045] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096  
> retry 1
> [103051.265156] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096  
> retry 2
> [103051.265281] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096  
> retry 3
> [103051.265406] ehci_hcd 0000:00:1d.7: detected XactErr len 1536/4096  
> retry 4

Precisely.

> According to the EHCI spec, XactErr is "Set to a one by the Host  
> Controller during status update in the case where the host did not  
> receive a valid response from the device (Timeout, CRC, Bad PID,
> etc.)"

Is there any way of controlling the number of retries in the host
controller? Or, perhaps, of controlling the time between retries so that
the device can shape it up again?

> Quite likely this is some kind of hardware problem - maybe the USB
> port doesn't quite provide enough power for the drive, etc.

I see. The first thing I thought about when I saw this comment of yours
was that there could be some heat issue and the drive not cooling
down.

In this particular case, the USB enclosure is externally powered and it
conatins a SATA drive. I also had never seen it occour before when
connected to an EHCI port on another system, even while transferring
more data.

> A lot of these USB enclosure devices are also rather poor quality in
> general..

Agreed. Not everybody does things correctly by the book. OTOH, these are
the devices present in "the real world". Would there be workarounds for
such situations?


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
