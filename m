Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbYKGH3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbYKGH3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYKGH32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:29:28 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:1402 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYKGH31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:29:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=twxbz1AwglpudM/eUcHW9Enye9xP1Y2H0Nz6h4w9+jX1n5Huf/P+rlGQfA/veUULyM
         zg9il8/OQuCdyg3OcVVLPJSMvkyGAf5RJxR702K1muCIGMxjqjcZNa7+Zoelu8aTWGWo
         QC5VMeE7MpztD/zZ2KlBfFGfF801/ohpcpaKU=
Message-ID: <8bd0f97a0811062329l26f8338ahbb62bab9e8284c36@mail.gmail.com>
Date: Fri, 7 Nov 2008 02:29:25 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] ALSA: have snd_BUG_ON() always refer to arguments
Cc: alsa-devel@alsa-project.org, "Mike Frysinger" <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <s5hk5bgqa61.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226023521-10037-1-git-send-email-vapier@gentoo.org>
	 <s5hod0sqcmt.wl%tiwai@suse.de>
	 <8bd0f97a0811062309m4029f612k4d3fe380e6d124df@mail.gmail.com>
	 <s5hk5bgqa61.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 02:15, Takashi Iwai wrote:
> At Fri, 7 Nov 2008 02:09:04 -0500,
> Mike Frysinger wrote:
>> On Fri, Nov 7, 2008 at 01:22, Takashi Iwai wrote:
>> > At Thu,  6 Nov 2008 21:05:21 -0500,
>> > Mike Frysinger wrote:
>> >> The snd_BUG_ON() macro should always expand its argument even if we're
>> >> forcing it to false.  This kills off unused warnings that did not exist
>> >> before the snd_assert() -> snd_BUG_ON() conversion.
>> >
>> > Andrew already change this differently.  Check with the latest version.
>>
>> what are you defining as "latest version" ?  i'm looking in torvalds
>> linux-2.6.git.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>
>> > And which warning did you get actually?
>>
>> a few codecs define local vars which only get used in snd_BUG_ON() ...
>> so if snd_BUG_ON() doesnt utilize cond, gcc whines that the var is
>> unused.
>
> I know it.  But I thought all these were removed in the actual codes.
> I'd like to see the real warning messages.

seems the warnings where in codec drivers we havent pushed into
mainline yet.  regardless, i dont think auditing code and changing it
just to avoid (cond) references is the way to go.  it also breaks
valid C code if there were side effects in the (cond) as any other
macro which does not properly utilize every argument exactly once.
-mike
