Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYFNVdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYFNVdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 17:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbYFNV1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 17:27:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:51060 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbYFNV06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 17:26:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YnWYmXE2nndwaKsmhGaG4e9vzSLH75tMIYsyYXgHwGy560hqZJsvIiqqNJ9Qds82eq
         n8z6N3Czc3INKqXms1oN+9oiBjRgcpM8jFi4p87icuYKspuKAnOB2tl8B08CYXXjaFPX
         swkk6iAfzhF73hP5YKT9ty+g3IdTvf9z3u0Kk=
Message-ID: <19f34abd0806141426o7ba13f91h6720db3609146e16@mail.gmail.com>
Date: Sat, 14 Jun 2008 23:26:58 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Joe Peterson" <joe@skyrush.com>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: "Alan Cox" <alan@redhat.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "David Newall" <davidn@davidnewall.com>, "Willy Tarreau" <w@1wt.eu>,
       "Harald Dunkel" <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48542F75.5070605@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48438126.3080308@t-online.de>
	 <20080604171056.GB17875@devserv.devel.redhat.com>
	 <4846FBF2.9010206@skyrush.com> <484FDB63.6050504@skyrush.com>
	 <19f34abd0806120452w433e9763v2ee92e2f278ae988@mail.gmail.com>
	 <485323C5.4030002@skyrush.com>
	 <19f34abd0806140045l259bcb93ie4b7bfa2d73bd4d@mail.gmail.com>
	 <48540343.4010200@skyrush.com>
	 <19f34abd0806141334w67547e84hf1021c0fd1139b8b@mail.gmail.com>
	 <48542F75.5070605@skyrush.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 10:52 PM, Joe Peterson <joe@skyrush.com> wrote:
> Vegard Nossum wrote:
>> Yeah, a user-space process can do this, and it's the right behaviour
>> for the kernel. I did post a program that would "reproduce" what
>> you're seeing. I do now believe that it's something timing-related, as
>> Alan suggested initially. (But timing-related with your scripts, that
>> is. I must say, that "sleep 2" does look a bit suspicious; I have no
>> idea what that is supposed to do :-))
>
> Ah, that is something I put in there to artificially make it more
> reproducible.  Here's the reason: when I first encountered the problem,
> it was happening if the home dir of the user was on the "btrfs"
> filesystem (the new checksumming one from Oracle).  This made me suspect
> btrfs initially.  But I reproduced the problem [more sporadically] when
> the home was on ext3 as well.  Since btrfs has a different performance
> profile, especially when first accessed after a mount (and it is a
> filesystem still under development, so some optimizations are yet to
> come), I figured it might be timing-related, and sure enough, adding the
> "sleep 2" proved that.

I'm not sure it is. Try adding sleep 3 instead. Because I have the
"sleep 2" when I run "su foo" as well, and I _didn't_ put it there:

[pid  6298] execve("/bin/sleep", ["sleep", "2"], [/* 47 vars */]
<unfinished ...>


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
