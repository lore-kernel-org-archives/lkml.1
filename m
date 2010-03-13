Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0CMOuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 09:50:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46312 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0CMOut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 09:50:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k6tLogSkA1l6TUCW58IzAJIpzj88Xq0Ouj6zocOUwsjYtS8GtgjsqfeTcNZ0757kfp
         6bDF/jiSeu4LMzjABRVYndg6ReaV1NtwT71YdXowTbRx9OKrpNr+r6ENoU4uNgUcw8E5
         PNfXgRKqZK6Ts5moTtcn5AjDqemHrOPonoB0w=
MIME-Version: 1.0
In-Reply-To: <20100312144854.cb94d9b4.akpm@linux-foundation.org>
References: <4B968834.3040609@gmail.com>
	 <21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>
	 <2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>
	 <21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>
	 <2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com>
	 <20100312144854.cb94d9b4.akpm@linux-foundation.org>
Date: Sat, 13 Mar 2010 15:50:48 +0100
X-Google-Sender-Auth: 7ce2f4c70742eb6b
Message-ID: <10f740e81003130650j76698721g75186091253bb99c@mail.gmail.com>
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
       Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 23:48, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 10 Mar 2010 13:15:25 +0100
> Marco Stornelli <marco.stornelli@gmail.com> wrote:
>
>> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>> > 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>> >> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>> >>> Hi,
>> >>>
>> >>> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>> >>>> Ramoops, like mtdoops, can log oops/panic information but in RAM.
>> >>>
>> >>> What is different from mtdoops + mtd-ram?
>> >>>
>> >>> Yoichi
>> >>>
>> >>
>> >> It can be used in a very easy way with persistent RAM for systems
>> >> without flash support. For this systems, with this driver, it's no
>> >> more needed add to the kernel the mtd subsystem with advantage in
>> >> footprint as I said in the description.
>> >
>> > right.
>> > But,
>> >
>> >> In addition, you can save
>> >> flash space and store this information only in RAM. I think it's very
>> >> useful for embedded systems.
>> >
>> > CONFIG_MTD_RAM uses only RAM.
>> > I think there's no big difference about this point.
>> >
>>
>> I meant with the "classic" use of mtdoops, therefore with a flash
>> partition without use MTD_RAM. Using MTD_RAM, it's more or less the
>> same thing, with the exception of "where" you want deploy the log. For
>> example: if in your system you have got a nvram you can use it without
>> problem, you need to specify the address of the nvram to the module.
>> Very simple. I  think it's a small driver but very useful, feedback
>> from other embedded guys are welcome.
>
> Seems sensible to me.  If you have a machine whose memory is persistent
> across reboots then you reserve an arbitrary 4k hunk of memory for
> collecting oops traces, yes?
>
> What tools are used for displaying that memory on the next boot?  How
> do those tools distinguish between "valid oops trace" and "garbage
> because it was just powered on"?  A magic signature?

On Amiga, `debug=mem' enables something like that, cfr. git grep dmesg
arch/m68k.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
