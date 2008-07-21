Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYGUMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYGUMea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbYGUMeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:34:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:56083 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYGUMeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vMmssBSO4sv8qlc4cU4AC62L/cfJJaZ2J0atuFaw2pV9BmcqO1CWwZ+icUpMomN/Ih
         2GbO0NtbMhQ96hZE4Oum3huQxfg/ivSSAtSbCGgEpUKP+DMd+jSGAXhHQVD5H42gzr8W
         +vHfxj+IleBSe8sqe4sWmVuUqdKgsu+N6zsss=
Message-ID: <6dd519ae0807210534k462858d6l13de6aaef29a4a9f@mail.gmail.com>
Date: Mon, 21 Jul 2008 15:34:19 +0300
From: "Brian Marete" <bgmarete@gmail.com>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: [PATCH] V4L: Link tuner before saa7134
Cc: LKML <linux-kernel@vger.kernel.org>, linux-dvb@linuxtv.org
In-Reply-To: <38354.simon.1216381906@5ec7c279.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
	 <38354.simon.1216381906@5ec7c279.invalid>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:51 PM, Simon Arlott <simon@fire.lp0.eu> wrote:
>
> On Fri, July 18, 2008 12:28, Brian Marete wrote:
>> On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
>>>
>>> #1 users can't set thetunertype anymore,
>>>    but the few cases oftunerdetection from eeprom we have should
>>>    work again for that price.
>>
>> Hello,
>>
>> Any patch yet for above issue? It seems to have made it into 2.6.26.
>>
>> I use saa7134 with everything, including the tuner modules, compiled
>> as a module. My card is detected as a flyvideo2000. The default tuner
>> for that card (#37) allows me to tune into TV but not to FM Radio. I
>> can access both functions (TV and FM Radio) if I override with
>> tuner=69, which is what I usually do. That override does not work on
>> 2.6.26.
>>
>> Any suggestions?
>
> Modify saa7134_board_init2 so that the manual tuner type setting isn't
> ignored. The first thing it does is to overwrite the current value
> (set earlier from module parameter) with the static values... even
> before trying to autodetect it.
>
> In saa7134-core.c saa7134_initdev:
>  dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> +dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
>
> In saa7134-cards.c saa7134_board_init2:
> -dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
> -dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;
>
> I think that will fix it.

And, indeed, it fixed it. I hope the patch will make it into the main-line.

Thanks.

-- 
B. Gitonga Marete
Tel: +254-722-151-590
