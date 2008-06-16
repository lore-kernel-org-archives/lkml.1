Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYFPRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYFPRMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYFPRML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:12:11 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:29574 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYFPRMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:12:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GqcigIE5iXxV0iXowsxcislrJPbXkLlBvIL+ltAqMt9GqDyTTM7ZaafZzaoF1ivUOn
         iTMSvs6SW3sJdDxYmyHol5AoY2z1mkNOFif1B76gKr5Vu/LyjyBJp5fGq7s/GbcKc+5x
         xP9beUjJ7a2jktgT93EWAZliIldzG0Xqz5oCA=
Message-ID: <dd18b0c30806161012s66000c75q19b387000f138a62@mail.gmail.com>
Date: Mon, 16 Jun 2008 17:12:08 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: audio: hda_intel azx_get_response timeout
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5htzft5n55.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806151043k46200e22lcaae79ad1f8209ed@mail.gmail.com>
	 <s5h63s9pbxe.wl%tiwai@suse.de>
	 <dd18b0c30806160957s20dfb513h1834dd1f9c3ecd5b@mail.gmail.com>
	 <s5htzft5n55.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 5:02 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 16 Jun 2008 16:57:07 +0000,
> Justin Mattock wrote:
>>
>> On Mon, Jun 16, 2008 at 4:44 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Sun, 15 Jun 2008 17:43:01 +0000,
>> > Justin Mattock wrote:
>> >>
>> >> I've noticed this([   14.630815] hda_intel: azx_get_response timeout,
>> >> switching to polling mode: last cmd=0x00bf1c00
>> >>  with 2.6.26-rc2 or 3, when connecting external speakers to listen to
>> >> music(keep in mind this was only once),
>> >> Now with kernel 2.6.26-rc5 and 6 I'm seeing this pop up every so
>> >> often,(seen this three times now). attached is dmesg of the message.
>> >> If I see anything else I'll send a post.
>> >
>> > Well, this is no fatal error but a warning, but of course better
>> > without it.
>> >
>> > It might be related with the position that runs.  I see the clock
>> > source tsc unstable message right after it, so the timeout check could
>> > be unreliable...
>> >
>> >
>> > Takashi
>> >
>>
>> Hmmm, Well, whenever this goes off, if and when it decides, I'm not
>> hearing anything different
>> with the sound. Seems like a minor issue nothing to intense.
>
> There will be no difference in the sound quality regarding this
> indeed.  In the polling mode, the driver tries to poll the codec
> receive buffer while it waits for the IRQ ack in the default
> (non-polling) mode.  So, you can need a few more cycles for polling,
> but it doesn't influence on the real performance at all.
>
> The switch to the polling mode occurs for some hardwares that don't
> issue the IRQ properly in the timely manner by any reason.  Then in
> your report, I thought it might be rather the time source issue.
> Well, just a wild guess, though.
>
>
> Takashi
>

maybe this occurs randomly due to me not having irq balancing turned
on in the kernel?
in any case it happens so seldom, it's not even noticeable.
either way, As long as you guy's are aware of this, I feel better, so the kernel
can rock on.
regards;

-- 
Justin P. Mattock
