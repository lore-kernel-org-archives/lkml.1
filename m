Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYGRLv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYGRLv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGRLvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:51:49 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40788 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbYGRLvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:51:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=KNRtTyiTpsTS85HxqD23zIcG6ZKchZR4MnZRAwAzWKuX8WP44unq6FAEWBJBM4N6vX9eYeli13mDof9ejbNib8buf/v+IoCHFl5yOPhOsTGRQg3mU48JvLLM8g4M+vjn;
Message-ID: <38354.simon.1216381906@5ec7c279.invalid>
In-Reply-To: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
References: <6dd519ae0807180428k30abd15eo60fd2856f7a43821@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:51:46 +0100
Subject: Re: [PATCH] V4L: Link tuner before saa7134
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Brian Marete" <bgmarete@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, linux-dvb@linuxtv.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, July 18, 2008 12:28, Brian Marete wrote:
> On Jul 14, 6:00 am, hermann pitton <hermann-pit...@arcor.de> wrote:
>>
>> #1 users can't set thetunertype anymore,
>>    but the few cases oftunerdetection from eeprom we have should
>>    work again for that price.
>
> Hello,
>
> Any patch yet for above issue? It seems to have made it into 2.6.26.
>
> I use saa7134 with everything, including the tuner modules, compiled
> as a module. My card is detected as a flyvideo2000. The default tuner
> for that card (#37) allows me to tune into TV but not to FM Radio. I
> can access both functions (TV and FM Radio) if I override with
> tuner=69, which is what I usually do. That override does not work on
> 2.6.26.
>
> Any suggestions?

Modify saa7134_board_init2 so that the manual tuner type setting isn't
ignored. The first thing it does is to overwrite the current value
(set earlier from module parameter) with the static values... even
before trying to autodetect it.

In saa7134-core.c saa7134_initdev:
 dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
+dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;

In saa7134-cards.c saa7134_board_init2:
-dev->tuner_type   = saa7134_boards[dev->board].tuner_type;
-dev->tuner_addr   = saa7134_boards[dev->board].tuner_addr;

I think that will fix it.

>
> Thanks,
>
> --
> B. Gitonga Marete
> Tel: +254-722-151-590
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Simon Arlott
