Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZESHRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZESHRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZESHQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:16:47 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:10501 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755365AbZESHQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:16:46 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Matt Fleming" <matt@console-pimps.org>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer - rewritten
Date: Tue, 19 May 2009 09:16:40 +0200
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090518203338.GB10274@console-pimps.org>
In-Reply-To: <20090518203338.GB10274@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905190916.40596.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt,

Am Montag, 18. Mai 2009 schrieb Matt Fleming:
> Ah, now I understand. I've also been contacted privately by someone
> who says that they've been experiencing similar issues and that your
> patch has fixed them. Clearly there are people out there with flaky
> hardware ;-)

Hmmm... Every hardware is flaky. Put a piece of hardware near your 
refrigerator or DECT base, and you will have EMP or HF problems.
Or use your finger and generate ESD pulses.

I am using a piezo where I have the GND pin connected to a wire to generate 
ESD pulses which have the same results as a 4 KV ESD generator:

http://www.vega-direct.at/buffet/chafing_dish_mit_zubehoer/gasanzuender/index.hsp

A software which do not behave gracefully in the presence of errors is not 
production quality for me.

> I feel that retrying data accesses should be done at a higher layer
> than the MMC/SD subsystem.

There is some sense in that. But then you must give some more information to 
the higher layers:

- the information that it makes sense to retry.
- If a retry is commanded by the upper layer, mark it as retry, so that the 
lower layer is able to react different if needed.

Retry is not only bare retry, it is also about recovering from a previous 
failure, and try to continue the (maybe lost) communication. Retry may be a 
multi-stage approach (first try a simple retry, second try to recover 
communication, third to reset the hardware and start from the beginning.)

So I fear that a retry logic in the upper layers must have so much information 
about what is going on there and how to fix the problems, that it might be a 
real hard work to implement as a general solution.

Now, the upper layers (I mainly use vfat file system) are doing no retry at 
all, and this is not acceptable IMO.

> This 
> patch solves a real world problem that is biting some people, and so
> based on that, the approach seems OK to me FWIW.

Fine. Note that the old code has already done retries for read operations.

> By the way, the indentation needs fixing here.

OK.

If the discussion is over, I will post an updated patch. I will wait for 
Pierre to comment.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
