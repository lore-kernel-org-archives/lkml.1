Return-Path: <linux-kernel-owner+w=401wt.eu-S934503AbZIEAEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503AbZIEAEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZIEAEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:04:10 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:63422 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934097AbZIEAED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:04:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=WeBx92dFy2Uv9F/oXbmNOalmXSDqQj/1iijVprE7yR0ZWe+JLwxS0SQvAd99DkBBGx
         rjRDMvintL8wiuUrZJIKXZoWvbrpbFll1yO5fMIbU9OZGsZm3ZksOV+yMQ9dnlHwU8XR
         NSYi+BhPERGjCnwjB4U69tvuajFIt5lYnfBfM=
MIME-Version: 1.0
In-Reply-To: <43e72e890909041548i553d63b6k1602eeb52920c4ec@mail.gmail.com>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com> 
	<43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com> 
	<1252001837.9336.2.camel@johannes.local> <20090903204319.GC3701@mosca> 
	<1252040671.9336.10.camel@johannes.local> <1252052757.26413.9.camel@pc1117.cambridge.arm.com> 
	<43e72e890909041421m243bbea6i95c26ab21dc8732d@mail.gmail.com> 
	<43e72e890909041458u505ce89tf38743dd6305bf7b@mail.gmail.com> 
	<1252103067.21380.1.camel@pc1117.cambridge.arm.com> <43e72e890909041548i553d63b6k1602eeb52920c4ec@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 4 Sep 2009 17:03:45 -0700
X-Google-Sender-Auth: 3ed45d6a825f561a
Message-ID: <43e72e890909041703k79326384ided33edfccaaeb0a@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak 
	reports
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 4, 2009 at 3:48 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> On Fri, Sep 4, 2009 at 3:24 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
>> On Fri, 2009-09-04 at 14:58 -0700, Luis R. Rodriguez wrote:
>>> On Fri, Sep 4, 2009 at 2:21 PM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
>>>
>>> > BTW I should not I got this kmemleak report after using the clear
>>> > command by painting objects black. I'll test it now with your
>>> > suggested changes.
>>>
>>> So I pulled your git://linux-arm.org/linux-2.6 master into my tree and
>>> didn't even need a 'clear' command now, the output of
>>> /sys/kernel/debug/kmemleak is empty :), so I suspect you have quite a
>>> few changes which should help avoid getting false positives.
>>>
>>> Will these changes make it for 2.6.32?
>>
>> The kmemleak branch is planned for the upcoming merging window.
>
> Ah great.
>
>> I don't
>> think you need to merge the master branch as it has a lot of
>> arm-specific code.
>
> That was a goof, thanks, I'll rebase onto your kmemleak branch.

I rebased and I still get these, even if I scan every now and then,
they stay up there.

On wireless_send_event() I can follow the allocated skb put onto the
skb queue wext_nlevents, and then schedule work is supposed to process
it on wireless_nlevent_process(). From there I am able to follow the
skb onto netlink_unicast() (for unicast data) but I do not see where
this ends up being freed. The compskb is set onto the
skb_shinfo(skb)->frag_list and not sure if netlink_unicast() ever
frees that.

  Luis
