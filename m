Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab0CNW40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 18:56:26 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38371 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab0CNW4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 18:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MalKkQ79FkvTZoaSm+mq0eMA1WZ19/92D9H72VOLJRTynujeH9pSkCHS9bfyoyaKJH
         74fDsPQdQcaMi650w3ifwoNvqt8StcD8k9DuETyd9qwDjKB1YEAEwSnEZKn/bfj7Py4n
         CnkN/gYQj1aIj1Rz+WzF8sB/Bi1kMO9tu9v4Y=
MIME-Version: 1.0
In-Reply-To: <4B9D506D.3000609@ziu.info>
References: <4B947393.2050002@kernel.org>
	 <alpine.DEB.1.10.1003090733330.9819@uplift.swm.pp.se>
	 <4B961D8F.3010500@ziu.info> <4B96E397.1040005@kernel.org>
	 <4B9D506D.3000609@ziu.info>
Date: Sun, 14 Mar 2010 18:56:20 -0400
Message-ID: <f875e2fe1003141556p1f6595e0m8ce2a17c1843c326@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: s ponnusa <foosaa@gmail.com>
To: Michal Soltys <soltys@ziu.info>
Cc: Tejun Heo <tj@kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has been following this thread and I might possibly be testing with
Windows XP soon. Will update the results.
-
SP

On Sun, Mar 14, 2010 at 5:09 PM, Michal Soltys <soltys@ziu.info> wrote:
> Tejun Heo wrote:
>>
>> I was thinking about testing XP booting this weekend but really want
>> to avoid it, so thanks a lot for the info.  I'll update the doc
>> accordingly but can you please enlighten me on how it works and what's
>> broken in detail?  So, XP should be fine with any alignment?
>>
>> Thanks.
>>
>
> Sorry for late reply.
>
> s/sp2/sp3 - although it shouldn't make a difference from sp2 onwards.
>
> Anyway - the tests I did were because of weird laptop, where I shrinked
> whole win7 stuff and having no primary partitions left to use, I tested my
> usual windows xp installation I deploy with ntfsclone. Originally that XP
> were installed from installation disk merged with sp3 (or how it's usually
> called in windows world - slipstreamed). Of course, windows xp itself will
> not present any options to install itself into logical partition in the
> usual way - but during later deployment it's not a problem to put it where
> one's want.
>
> It's possible that this wouldn't work, if windows were installed first from
> pre-sp2 media, and then service pack was installed (in such case, ntldr in
> C:\ is not updated afaik). It's also possible, that "brute-force" copied
> pre-sp2 or win2k to a partition made with either - a) xp sp2+'s disk manager
> or b) mkfs.ntfs and with updated most recent ntldr -  would boot as well
> (the partition requirement is due to potential differences between the code
> in bootsector, or more precisely - $Boot - first 8KiB of ntfs partition).
>
> Obvious requirements besides the above (ntldr, perhaps $Boot as well) are:
>
> - mentioned "hidden sectors" (must be manually adjusted, recent syslinux's
> chain.c32 has option to do it automatically)
> - adjusted boot.ini (to point to new partition, eventually other windowish
> stuff as necessary)
>
> As you can see, there're many "if"s and combinations here that I didn't
> test.
>
> On a related note - ironically, while I had 0 problems making it work
> through syslinux (both regular chaining and through direct ntldr loading) -
> I couldn't make win7's bootmgr (bcd, bcdedit ....) do it properly. Oh well.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
