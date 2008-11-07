Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbYKGH4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbYKGH4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYKGH40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:56:26 -0500
Received: from rn-out-0910.google.com ([64.233.170.186]:62037 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYKGH40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OeBIIYbbOtIl7HtdNn6W/xj06IwVZ/YXRkoDOu2A4X/BcLN5+43lW3LFMhAoBawR6u
         SANs4uo9vxpqSp5S4m63fzk0xyxapJlalVjOtapcVGvZCfXMnkx1V7OwaBv6S/XNI9uL
         RLrUwTYeFDBqT9kWumVFa5g9a5WScMGQFSRfo=
Message-ID: <8bd0f97a0811062356k6c9c7e3dle53500c092565a32@mail.gmail.com>
Date: Fri, 7 Nov 2008 02:56:24 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: alsa-devel@alsa-project.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hd4h8q974.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hod0sqcmt.wl%tiwai@suse.de>
	 <8bd0f97a0811062309m4029f612k4d3fe380e6d124df@mail.gmail.com>
	 <s5hk5bgqa61.wl%tiwai@suse.de>
	 <8bd0f97a0811062329l26f8338ahbb62bab9e8284c36@mail.gmail.com>
	 <s5hd4h8q974.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 02:36, Takashi Iwai wrote:
> At Fri, 7 Nov 2008 02:29:25 -0500,
> Mike Frysinger wrote:
>> On Fri, Nov 7, 2008 at 02:15, Takashi Iwai wrote:
>> > At Fri, 7 Nov 2008 02:09:04 -0500,
>> > Mike Frysinger wrote:
>> >> On Fri, Nov 7, 2008 at 01:22, Takashi Iwai wrote:
>> >> > At Thu,  6 Nov 2008 21:05:21 -0500,
>> >> > Mike Frysinger wrote:
>> >> >> The snd_BUG_ON() macro should always expand its argument even if we're
>> >> >> forcing it to false.  This kills off unused warnings that did not exist
>> >> >> before the snd_assert() -> snd_BUG_ON() conversion.
>> >> >
>> >> > Andrew already change this differently.  Check with the latest version.
>> >>
>> >> what are you defining as "latest version" ?  i'm looking in torvalds
>> >> linux-2.6.git.
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>> >
>> >> > And which warning did you get actually?
>> >>
>> >> a few codecs define local vars which only get used in snd_BUG_ON() ...
>> >> so if snd_BUG_ON() doesnt utilize cond, gcc whines that the var is
>> >> unused.
>> >
>> > I know it.  But I thought all these were removed in the actual codes.
>> > I'd like to see the real warning messages.
>>
>> seems the warnings where in codec drivers we havent pushed into
>> mainline yet.  regardless, i dont think auditing code and changing it
>> just to avoid (cond) references is the way to go.  it also breaks
>> valid C code if there were side effects in the (cond) as any other
>> macro which does not properly utilize every argument exactly once.
>
> IIRC, just giving 0 in a macro like your patch resulted in another
> warning messages in case it's used plainly like:
>
>        snd_BUG_ON(foo);
>
> That's the reason why { 0; } was used in the first place.  But, this
> caused yet another warning messages depending on gcc versions, thus
> Andrew fixed it previously.
>
> I think the best way is to change the latest code like:
>
> #define snd_BUG_ON(cond)        __snd_bug_on(0 && (cond))

that should work i think ...
-mike
