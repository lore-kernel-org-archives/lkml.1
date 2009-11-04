Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbZKDXsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbZKDXsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbZKDXsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:48:41 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:32856 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361AbZKDXsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MaL/1Y/YQtFsePogaDdVAgZElaLFRZPHZXpb38GeAyqAp/BCtn12TemuIqVq/vMXOk
         4YBts5vsNTPRtfeLKNvzXIdYyEla/zspnp8KtbgmdmE/lduYQDjkc3DvDU0VLE1QGW6L
         avwHsQSXlzjKBCbCus9TRtk1SL97SBffAfDaM=
MIME-Version: 1.0
In-Reply-To: <1257253713.6277.7.camel@frodo.giritli.eu>
References: <1257179328.13327.34.camel@frodo.giritli.eu>
	 <4AEF7402.1010901@gmail.com>
	 <1257253713.6277.7.camel@frodo.giritli.eu>
Date: Wed, 4 Nov 2009 17:48:46 -0600
Message-ID: <51f3faa70911041548x70d5e4a1oabdf1739dad355c7@mail.gmail.com>
Subject: Re: Faulty MTRR setups in Toshiba laptops crash video drivers
From: Robert Hancock <hancockrwd@gmail.com>
To: mehmet@giritli.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 3, 2009 at 7:08 AM, Mehmet Giritli <mehmet@giritli.eu> wrote:
> On Mon, 2009-11-02 at 18:06 -0600, Robert Hancock wrote:
>> On 11/02/2009 10:28 AM, Mehmet Giritli wrote:
>> > Hello all,
>> >
>> > On some laptops using ATI 3650HD radeon chipsets and 4GB ram (and may be
>> > others as well), it is impossible to start any xserver due to (faulty?)
>> > mtrr setups on the machine. The computer locks up or just gives an
>> > unresponsive black screen. There are various drivers for radeon cards
>> > and the crash occurs in all of these drivers in the very same way!
>> >
>> > This bug seems to occur mostly on Toshiba laptops with ATI graphic
>> > cards. For some people, CONFIG_MTRR_SANITIZER seemed to cure the issue
>> > but made no difference for many others like me.
>> >
>> > RadeonHD people seem to have problems in understanding the nature of
>> > this bug. Please have a look at the threads:
>> >
>> > http://lists.opensuse.org/radeonhd/2009-05/msg00040.html
>> >
>> > and,
>> >
>> > http://bugs.freedesktop.org/show_bug.cgi?id=20645
>> >
>> > for problem reports and dev responses. RadeonHD devs suggest that some
>> > laptops have weird mtrr setups and this must be fixed in the kernel code
>> > and not the driver code.
>>
>> Unfortunately I don't see enough details to be able to tell what lead
>> them to this conclusion. Can you post the output of:
>>
>> lspci -vv
>> cat /proc/mtrr
>
> lspci -vv
> http://bugzilla.kernel.org/attachment.cgi?id=23634
>
> /proc/mtrr when 4GB installed
> http://bugzilla.kernel.org/attachment.cgi?id=23632
>
> /proc/mtrr when 2GB installed
> http://bugzilla.kernel.org/attachment.cgi?id=23633
>
> There is also a bug report that I opened a while back here:
> http://bugzilla.kernel.org/show_bug.cgi?id=14054

So it appears that your machine has an MTRR entry which marks the
first 16MB of the video card's video RAM BAR area as "write-through",
which seems quite clearly wrong. However, all that I would expect to
see this do would be to cause X to be unable to map the BAR as
write-combining (which you can see from dmesg is indeed occurring)
causing a loss of performance. And the same MTRR is there in the 2GB
case as in the 4GB case. So I don't think the question of why it works
with 2GB and not with 4GB is anything to do with MTRRs..
