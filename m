Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKGJay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKGJay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYKGJaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:30:46 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:63362 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYKGJao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:30:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PfkFeWB9ICdU/8FWIpzenR2N4zahf5xakk3PXpE5u55T7aTaljFbIal49JFI2lvX8U
         EV9E2qxdVkjsmtsWjYMK4kalHsGO4HOxsTvOZM5y9OJVJQBd9j3hfnE/MWqTqgPoh35j
         i9C9L6PAMafFbTT7FEJGMeasMArFxugcz6K+c=
Message-ID: <8bd0f97a0811070130w540f8110l978c8910fad924e0@mail.gmail.com>
Date: Fri, 7 Nov 2008 04:30:43 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: alsa-devel@alsa-project.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5h4p2kq71k.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hod0sqcmt.wl%tiwai@suse.de>
	 <8bd0f97a0811062309m4029f612k4d3fe380e6d124df@mail.gmail.com>
	 <s5hk5bgqa61.wl%tiwai@suse.de>
	 <8bd0f97a0811062329l26f8338ahbb62bab9e8284c36@mail.gmail.com>
	 <s5hbpwsq92z.wl%tiwai@suse.de>
	 <8bd0f97a0811062357y52ff0107yee74c0a2ff010019@mail.gmail.com>
	 <s5h7i7gq7xz.wl%tiwai@suse.de>
	 <8bd0f97a0811070005r6a9fb1e1s9fd88bd264ef8ae2@mail.gmail.com>
	 <s5h4p2kq71k.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 03:22, Takashi Iwai wrote:
> At Fri, 7 Nov 2008 03:05:56 -0500, Mike Frysinger wrote:
>> On Fri, Nov 7, 2008 at 03:03, Takashi Iwai wrote:
>> > At Fri, 7 Nov 2008 02:57:40 -0500, Mike Frysinger wrote:
>> >> On Fri, Nov 7, 2008 at 02:38, Takashi Iwai wrote:
>> >> > At Fri, 7 Nov 2008 02:29:25 -0500, Mike Frysinger wrote:
>> >> >> it also breaks
>> >> >> valid C code if there were side effects in the (cond) as any other
>> >> >> macro which does not properly utilize every argument exactly once.
>> >> >
>> >> > BTW, what do you mean this exactly?
>> >>
>> >> any potent statement.  such as assignment or pre/post increment/decrement or ...
>> >
>> > Well, in that case, such a code itself is buggy :)
>>
>> i'm not advocating doing this sort of thing, i'm saying that
>> functions/macros should be written correctly so as to not break
>> standard C behavior.  a guy developing a codec driver could waste a
>> lot of time because of this sort of thing.
>
> Well, no, it's a clear bug of the driver.
>
> A macro that ignores arguments is normal.  Or do you think assert()
> isn't a part of "standard" C ? :)

we arent talking about assert() here nor are we talking about assert()
behavior, but i would say it was a poor decision.  the fact that it's
called snd_BUG_ON() instead of snd_WARN_ON() is also a bit broken imo.
 BUG() kills the kernel while WARN() complains, and snd_BUG_ON() is
clearly in the latter category.

that said, you could just define snd_BUG_ON() in terms of WARN_ON()
all the time:
#ifdef CONFIG_SND_DEBUG
# define SND_DEBUG 1
#else
# define SND_DEBUG 0
#endif
#define snd_BUG() WARN(SND_DEBUG, "BUG?\n")
#define snd_BUG_ON(cond) WARN(SND_DEBUG && (cond), "BUG? (%s)\n",
__stringify(cond))
-mike
