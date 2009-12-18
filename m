Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbZLRTzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbZLRTzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZLRTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:55:45 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:63272 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZLRTzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vVEeezV+K/5nXGXPTO1fcWNj/66+pruS1q8uwCMKzfYwwVDP4fcF7tfJTYU9AaTePq
         T5xQJaLdntkGb9FA7p2byTjcCctBlOdvsqy0YqKVxv91Nbo13IQz8HKDi6lUemEM+xi9
         WcyQRhwW0M7X3WncfxkbQTIt0MpRT0w6h71wo=
MIME-Version: 1.0
In-Reply-To: <43e72e890912181119t53e01ec2y5dc8687d23f7a668@mail.gmail.com>
References: <43e72e890912180926oad3b09fl6b7951864a836700@mail.gmail.com> 
	<200912181838.20204.bzolnier@gmail.com> <43e72e890912181119t53e01ec2y5dc8687d23f7a668@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 18 Dec 2009 11:55:24 -0800
Message-ID: <43e72e890912181155h444956a3tf228ddd8d281a9d3@mail.gmail.com>
Subject: Re: git pull on linux-next makes my system crawl to its knees and beg 
	for mercy
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 11:19 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Dec 18, 2009 at 9:38 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
>> On Friday 18 December 2009 06:26:29 pm Luis R. Rodriguez wrote:
>>
>>> on my kernel logs. Bewildered with this issue I set out to prove to
>>> myself this issue was not a 2.6.32 issue and booted other kernels,
>>> including Ubuntu's distro kernel on 2.6.31 and then later my own built
>>> fresh 2.6.27.41 kernel. The issue was reproducible on all three
>>> kernels!
>>>
>>> This lead me to believe this was a system / hard drive issue and
>>> embraced myself for a system fix. I yet needed to prove this was
>>
>> Just some hints for ruling out the system / hard drive problem.
>>
>> smartctl -a /dev/sdx is your friend for checking your disk (keep an eye
>> on anything suspicious like re-allocated sector count going up etc.)
>
> Sweet thanks, here's my current output, I'll try later after I get
> some day work done to pull linux-next and make it moan. Let me know if
> you see anything fishy.

<-- snip full log -->

> Also available at:
>
> http://bombadil.infradead.org/~mcgrof/logs/2009/12/smart-ctl-sda2.txt
>
>> It could be also fs related issue that shows up only under specific
>> conditions
>
> OK -- I see, I used a fresh new ext3, did not make the jump to ext4.
>
>> (i.e. almost full partition -- some file-systems starts to
>> crawl when the amount of available free space gets low).
>
> Got it, thanks, so partition has a lot of room.
>
> mcgrof@tux ~ $ df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda2              91G   43G   44G  50% /
>
> Also ony have one partition.

GSmartControl is very cool, just ran the short self test and it passed
without issues. I'll now run the extended self tests. I'll not that
right after the self test I had to checkout the 2.6.32.y branch on
hpa's tree and noticed similar type of slow down as I did with pulling
linux-next. Only thing with linux-next is it takes ages complete which
just makes waiting unbearable. This all makes me suspect its something
else. But lets seee what these results on the GSmartControl yield.

  Luis
