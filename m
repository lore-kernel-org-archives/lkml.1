Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYKXJui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYKXJui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbYKXJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:50:29 -0500
Received: from lucidpixels.com ([75.144.35.66]:50146 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbYKXJu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:50:28 -0500
Date: Mon, 24 Nov 2008 04:50:26 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stian Jordet <liste@jordet.net>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
In-Reply-To: <1227485956.5145.10.camel@chevrolet>
Message-ID: <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
References: <1226760254.5089.11.camel@chevrolet>  <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>  <1227476908.32357.5.camel@chevrolet>  <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan> <1227485956.5145.10.camel@chevrolet>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-666903729-1227520226=:25866"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-666903729-1227520226=:25866
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 24 Nov 2008, Stian Jordet wrote:

> s=C3=B8., 23.11.2008 kl. 17.25 -0500, skrev Justin Piszcz:
>> As the original posted stated:
>>
>> 1. please post dmesg output
>> 2. you may want to include your kernel .config
>> 3. xfs_info /dev/mdX or /dev/device may also be useful
>> 4. you can also check fragmentation:
>>     # xfs_db -c frag -f /dev/md2
>>     actual 257492, ideal 242687, fragmentation factor 5.75%
>> 5. something sounds very strange, I also run XFS on a lot of systems and
>>     have never heard of that before..
>> 6. also post your /etc/fstab options
>> 7. what distribution are you running?
>> 8. are -only- the two fujitsu's (raid0) affected or are other arrays
>>     affected on this HW as well (separate disks etc)?
>> 9. you can also compile in support for latency_top & power_top to see
>>     if there is any excessive polling going on by any one specific
>>     device/function as well
>
> 1 & 2: Oh, sorry I forgot to attach dmesg and config in the last mail.
>
> 3:
> root@chevrolet:~# xfs_info /dev/sdb1
> meta-data=3D/dev/sdb1              isize=3D256    agcount=3D32,
> agsize=3D11426984 blks
>         =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D365663488,
> imaxpct=3D25
>         =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
>         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-cou=
nt=3D0
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
>
> 4:
> root@chevrolet:~# xfs_db -c frag -f /dev/sdb1
> actual 380037, ideal 373823, fragmentation factor 1.64%
>
> 6: The only mount-option is relatime, which Ubuntu adds automatically.
> Hmm. I haven't tried to mount without that option. Well, didn't help
> without it neither, tried just now.
>
> 7: Ubuntu 8.10 Intrepid. This is a new system, and it has never run
> anything other than Intrepid. This affects both the standard kernel, and
> the vanilla 2.6.27.7 that I have compiled (dmesg and config attached is
> from that kernel). Have also tried both 64 bit and 32 bit (just for fun)
>
> 8: I'll explain my setup a little bit more. I explained the hardware in
> my first post. But I have the two Fujitsu SAS disks in RAID-0,
> with /dev/sda1 as root, and /dev/sda2 as home. Earlier they were both
> xfs, and dog slow. I have now converted both to ext3, and everything is
> normal. In addition I have four Seagate ST3500320AS 500GB SATA disks in
> hardware RAID-5 on the same controller. This 1,5TB array is still xfs.
> It also had and has the same symptoms.
>
> 9: I don't know how to do that. But what ever it is, it doesn't happen
> with ext3...
>
> Thanks for looking into this!
>
> Regards,
> Stian
>

While there still may be something else wrong, the first problem I see is=
=20
your sunit and swidth are set to 0.

Please read, a good article on what they are and how to set them:
http://www.socalsysadmin.com/

Justin.
---1463747160-666903729-1227520226=:25866--
