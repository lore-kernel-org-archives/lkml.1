Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZCLC2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZCLC2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbZCLC2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:28:33 -0400
Received: from web4106.mail.ogk.yahoo.co.jp ([124.83.200.68]:24555 "HELO
	web4106.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755633AbZCLC2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:28:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=WSPAjkSTyLo48Zy7CB9C5LJT2tr3b/n+JmI4Rs9IsYaLfAotTGYVjjAU2HRHnR38gB9pfA8Wct71gyYSPNfiO4G5rJRGL3KhfHJBtG7hlqQoxaBiKx+Vvkf4diHgSpn8  ;
Message-ID: <20090312022825.44571.qmail@web4106.mail.ogk.yahoo.co.jp>
Date: Thu, 12 Mar 2009 11:28:25 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: Re: Off-by-one in both LIBATA and IDE drivers
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, n0diamond@yahoo.co.jp
In-Reply-To: <49B85312.5030905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Norman Diamond wrote:
>> Alan Cox wrote:
>>> Norman Diamond wrote:
>>>
>>>> It looks like both LIBATA and the old IDE drivers
>>>> have an off-by-one error in deciding whether to
>>>> use READ SECTOR(S) instead of READ SECTOR(S) EXT.
>>>
>>> This was fixed some time ago, you need a newer
>>> kernel.
>> 
>> Well, either that or I need an older kernel.  It
>> was also fixed in 2.6.20, for which I think there
>> was a ready-made Slax distribution.
>> 
>> On another topic, trying 2.6.20 in whatever Slax
>> distribution it was, an Intel ICH7M had DMA
>> enabled on both /dev/hda and /dev/hdc.  I
>> understand that [subsequent changes losing DMA]
>> is considered to be by design not a bug.
> 
> You really shouldn't use the IDE drivers with SATA
> devices, if that's what you're talking about as far
> as the previous behavior. They were really never
> designed for it.

There's next to nothing that I can do about it.
If the BIOS sets the Intel chip to present an ATA
interface then the IDE drivers take control early in
the boot process.  If the BIOS sets the Intel chip to
present a SATA interface then LIBATA takes control
early in the boot process.

I'm considering constructing a boot menu where the
default command line has hda=noprobe hdb=noprobe
hdc=noprobe hdd=noprobe, and an alternate boot option
omits those.  Even if this will be reliable enough, it
won't be easy to explain to customers (if you don't
believe that then read some tech support stories).

> Realistically, although some people still work on
> it, testing coverage of the old IDE drivers is not
> that great these days, since most distributions no
> longer use it.

Even Knoppix 6.0.1, whose kernel isn't too antique
yet, assigned /dev/hda and /dev/hdc on my Dell D820
with ICH7M.

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
