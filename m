Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZGVCDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZGVCDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 22:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbZGVCDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 22:03:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:45357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZGVCDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 22:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ChqL2lp+tDoZFAtw6Aig3cGdcYpf9HDt5mYXdYpIXEEgY1Sfhne1bBHI+dtpxaxnpz
         GEXTPXdX6OuXs/qRufjgCsEc/rSMLyX4wSxqXkeprmvsn4xKFqYrSghIszTakxTwRKVW
         paJZK696mL62paPo43rzpGjUStifCEogT/Umc=
Message-ID: <4A667231.3020809@gmail.com>
Date: Wed, 22 Jul 2009 09:58:09 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Daniel Ribeiro <drwyrm@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 1/6] regulator: Add regulator_get_exclusive() API
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1248209397.4333.50.camel@brutus>
In-Reply-To: <1248209397.4333.50.camel@brutus>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Ribeiro wrote:
> Em Ter, 2009-07-21 às 16:00 +0100, Mark Brown escreveu:
>> Some consumers require complete control of the regulator and can't
>> tolerate sharing it with other consumers, most commonly because they need
>> to have the regulator actually disabled so can't have other consumers
>> forcing it on. This new regulator_get_exclusive() API call allows these
>> consumers to explicitly request this, documenting the assumptions that
>> they are making.
>>
>> In order to simplify coding of such consumers the use count for regulators
>> they request is forced to match the enabled state of the regulator when
>> it is requested. This is not possible for consumers which can share
>> regulators due to the need to keep track of the ownership of use counts.
>>
>> A new API call is used rather than an additional argument to the existing
>> regulator_get() in order to avoid merge headaches with driver code in
>> other trees.
>>
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Thanks for finally fixing the mmc/regulator issue. ;)
> 
> Can you update pxamci.c and twl4030-mmc.c to make use of this new API?
> 

I think that deserves another two patches for making use of this
new API.
