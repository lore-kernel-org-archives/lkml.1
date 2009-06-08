Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZFHPKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZFHPKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZFHPKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:10:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46425 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZFHPKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=plMgbwixQ9RnXZkVrMjqbBG9+MF+curks1nD5W3zUx+32LmZIsvBEr37vEEypcol1v
         G2ZbAKiYrWMXQGo0gUcEbIEA/vlXP99kXAbw2VXFFGK7KBC7dncTmXabvZ8skYlpD262
         btbGPZ7VyTrUe5hBY3TRu/ZfklttWslg5/bI0=
MIME-Version: 1.0
In-Reply-To: <1244471000.4079.36.camel@mulgrave.site>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <1244471000.4079.36.camel@mulgrave.site>
Date: Mon, 8 Jun 2009 16:04:46 +0100
Message-ID: <c6b1100b0906080804q6d29226bie2cd719e5d532aed@mail.gmail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
From: Chris Clayton <chris2553@googlemail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: NeilBrown <neilb@suse.de>, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

2009/6/8 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2009-06-08 at 09:08 +0100, Chris Clayton wrote:
>> Hi Neil,
>>
>> Thanks for the reply.
>>
>> 2009/6/7 NeilBrown <neilb@suse.de>:
>> > On Mon, June 8, 2009 8:31 am, Jaswinder Singh Rajput wrote:
>> >> On Sun, 2009-06-07 at 19:38 +0100, Chris Clayton wrote:
>> >>> 2009/6/7 Jaswinder Singh Ra
>> >>> >> > http://img231.imageshack.us/img231/8931/dscn0610.jpg
>> >
>> > This message says that it found a vfat filesystem on 8:3x (I cannot see
>> > what digit should be 'x').  That is probably sdc1 or sdc2. Maybe even
>> > sdc6 or sdc7.
>> > However the vfat filesystem didn't have /sbin/init.
>> >
>>
>> >>> http://img99.imageshack.us/my.php?image=dscn0617b.jpg
>> >
>> > This one says it couldn't find anything at 8,22, which I think
>> > should be sdb6.
>> > It also shows that you have and sdc6, but sdb only goes up to sdb3.
>> >
>> > So it seems that your disk drives have changed name - not a wholely
>> > unexpected event these days.
>> >
>> > We now need answers to questions like:
>> >  - what device do you expect the root filesystem to be on
>> >  - how is the kernel being told this?  Maybe it is hard coded
>> >    into your initrd.  Knowing which distro and what /etc/fstab
>> >    says might help (though it wouldn't help me, I'm just about out
>> >    of my depth at this point)
>> > Maybe if you changed /etc/fstab to mount by uuid instead of hardcoding
>> > e.g. /etc/sdb3, and then run "mkinitramfs" or whatever, it might work.
>> >
>>
>> Yes, I've just been looking at the photographs of the panics again and
>> I've noticed that two of my discs are being detected in the "wrong
>> order". There are three HDDS. The first, /dev/sda, is the master on
>> the first IDE port and contains sda1..sda7. The second, normally
>> /dev/sdb, is the slave on that port and contains sdb1..sdb6. The
>> third, normally /dev/sdc, is attached to the first SATA port and
>> contains sdc1..sdc3. The second photograph I posted shows that sdb and
>> sdc have been reversed. The first partition on the disc that is
>> normally /dev/sdb does indeed have a FAT32 filesystem in the first
>> partition.
>>
>> By the way, I should have said that in between the panics that the two
>> photographs show, I copied contents of /dev/sdc1, which I normally
>> boot from, to /dev/sdb6, so that I minimised the risk to sdc1 in the
>> reboot festival that bisecting would involve. I also, of course,
>> changed the name of the root partition that is passed to the kernel by
>> GRUB and amended /etc/fstab on /dev/sdb6. That's why the partitions
>> shown in the photographs seem inconsistent. Sorry I forgot to mention
>> that - I really shouldn't do these things late at night :-).
>
> Actually, you can save yourself a lot of pain by mounting by label
> instead ... that way both grub and fstab will find your root disc even
> if it has swapped order.
>
>> As I indicate above, when booting the partition I have set up to do
>> this bisecting,  I expect the root filesystem to be on /dev/hdb6. As I
>> also indicate, this information is passed to the kernel through GRUB's
>> /boot/grub/menu.lst. The kernel is configured specifically for my
>> system and the drivers needed to boot the system are built in to the
>> kernel, so I don't use an initrd. IIRC, that's the way Slackware is
>> installed today, except, of course, it's a big fat kernel with all
>> drivers needed to boot any system built in. I could be wrong on that
>> though, it's a while since I installed
>
> The fact that a slave on the first channel is detected after the SATA
> indicates a problem with async probing.  What are the two drivers for
> these?
>

I think this is the relevant part of my .config:

CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y <<<<=================
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set

The ATA/(E)IDE driver is disabled.

Chris

> James
>

-- 
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
