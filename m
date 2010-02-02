Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0BBEUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 23:20:22 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:58661 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BBEUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 23:20:15 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 23:20:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WNeUyWy5WcpYhdcpMoXPT9/SDKyrjE77crWTus+BKo7NwgGr8kVLna2e4idq3Raeh+
         atkr8aMaZx1mGYAAY5hjhGZr0I8c8OdidbRqAnnh9xdhpnwgF96rPqIPtJgEpvVuLWJ8
         32zc4k2I2mPQ6gXkjXX2ly4RAQS5308VW1xE8=
MIME-Version: 1.0
In-Reply-To: <1265044080.25140.266.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com> <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com> 
	<20100201144745.GC26011@rakim.wolfsonmicro.main> <1265044080.25140.266.camel@Joe-Laptop.home>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 1 Feb 2010 23:13:04 -0500
Message-ID: <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
Subject: Re: [PATCH 10/10] sound/soc/blackfin: Fix continuation line formats
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 12:08, Joe Perches wrote:
> On Mon, 2010-02-01 at 14:47 +0000, Mark Brown wrote:
>> On Sun, Jan 31, 2010 at 12:02:12PM -0800, Joe Perches wrote:
>> > String constants that are continued on subsequent lines with \
>> > are not good.
>> >
>> > Signed-off-by: Joe Perches <joe@perches.com>
>>
>> Gah, I thought I'd caught most of these when reviewing.  If you're using
>> a script to pick this stuff up it'd be worth checking for extraneous
>> continuations in the middle of code - outside of macros there's little
>> call for it.
>>
>> Applied, thanks.
>
> There are a few false positives and probably a few missing using
>
>        grep -rP --include=*.[ch] '".*\\$' * | \
>        awk '{ if ((gsub("\"", "\"") % 2) == 1) print $0; }'
>
> Most of the uses are __asm__ __volatile__ which could be
> considered unsightly but don't impact logging messages.
>
> The rest could/should be fixed.

*cough* checkpatch.pl *cough*

the Blackfin alsa fixes all look good to me, thanks
-mike
