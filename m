Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXBZJXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXBZJXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 04:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbXBZJXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 04:23:09 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:26518 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXBZJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 04:23:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kh/r7tCz83cCIYaf9/z0NOyUR6A24ahzrSevohGA6fjhHWiSkcbxmF8Yv9w3Gn6hiunRiZ9v/7muTMewW+lOC6wGuxluu9nQKSD9PQB7ZZCuHW+Eh6wCIflylraqI6IMovJox/BGLldowwsCYJ8fs0CgJ52D9TbP5pYhx83AQtY=
Message-ID: <8d158e1f0702260123y4380d88k3ca789efb0a91e3c@mail.gmail.com>
Date: Mon, 26 Feb 2007 10:23:04 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [PROBMEL] MD doesn't like /dev/disk/by-id
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <17890.41662.486226.273826@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702260055m5d3cf93cqce58e366d677c090@mail.gmail.com>
	 <17890.41662.486226.273826@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/07, Neil Brown <neilb@suse.de> wrote:
>   ARRAY /dev/md1 UUID=xxxxx:xxxxx:Xxxxxx:xxxxx
>
> and it should find the right devices and assemble them without
> problems.

That's my point, this is the *only* way working at the moment when
using mdadm --assemble , since /dev/disk/by-id* tells me no suiteable
drives, /dev/sd? DOES work but isnt reliable since /dev/sdl is not
always /dev/sdl but can be /dev/sdc the next reboot :D

>
> The only supported way to assemble arrays when md is a module is to
> use mdadm.  Mdadm has several ways to identify an array.  Check the
> man page.

I know, and i use mdadm. I used to use /dev/sd? since I did a simple
migration from raidtools to mdadm and this was the easiest way, then I
started to use libata which mangled my drive order every reboot, so I
got adviced to use /dev/disk/by-id/* , and now I am using UUID=some
128 bits hash here

> Suggestions for specific improvements to the md and mdadm documentation
> are always welcome.  Read mdadm.8 again and then tell me what you
> wanted it to tell you that wasn't clear.

Well, what I am kinda trying to say is: function that used to work
prior to 2.6.20 doesn't seem to be working anymore :D

mdadm -assemble doesn't work with /dev/disk/by-id/* is used.
And /dev/sd? is not useable due to the drive order not being the same
after every reboot, but this is more a libata/udev problem I guess.

I am in the train now, I will do the mdadm -v thingy as soon as I am
at a somewhat more stable connection than 2Mbit HDPSA

Patrick
