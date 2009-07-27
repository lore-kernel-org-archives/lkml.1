Return-Path: <linux-kernel-owner+w=401wt.eu-S1750842AbZG0EQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842AbZG0EQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 00:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZG0EQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 00:16:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:43848 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZG0EQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 00:16:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xjpvOs1kw0pTKvIyVaeL7WWCZxhMzDOp9kukcac70Z7p/9G3fr8cNAHWaBdY4vkbvH
         gNhzSvdkgv+7uxySUUyAOs0aiFAZscAcZpFKu3D5KsTWZlvv3EA06Ew0OGD7mobGbKn9
         U9jarjrQ6+gkDi36bfgPqIO/HSWJovakbw/Dk=
Message-ID: <4A6D2A27.8010004@gmail.com>
Date: Mon, 27 Jul 2009 12:16:39 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: da903x: add support for DA9030 BUCK2 with
 DVM
References: <1248594842-23456-1-git-send-email-mike@compulab.co.il> <1248601239.25964.883.camel@vega.slimlogic.co.uk> <4A6C313C.9050101@compulab.co.il>
In-Reply-To: <4A6C313C.9050101@compulab.co.il>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:
> 
> Liam Girdwood wrote:
>> On Sun, 2009-07-26 at 10:54 +0300, Mike Rapoport wrote:
>>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>>> ---
>>>  drivers/regulator/da903x.c |   17 ++++++++++++-----
>>>  1 files changed, 12 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
>>> index b8b89ef..fab755d 100644
>>> --- a/drivers/regulator/da903x.c
>>> +++ b/drivers/regulator/da903x.c
>>> @@ -367,24 +367,24 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
>>>  	.enable_bit	= (ebit),					\
>>>  }
>>>  
>> Looks fine but did not apply :-
>>
>> Applying: regulator: da903x: add support for DA9030 BUCK2 with DVM
>> error: patch failed: drivers/regulator/da903x.c:367
>> error: drivers/regulator/da903x.c: patch does not apply
>> Patch failed at 0001 regulator: da903x: add support for DA9030 BUCK2 with DVM
>>
>> Could you regenerate against the regulator tree for-next branch.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git
> 
> It seems I'm getting senile. The BUCK2 is already supported, moreover I've acked
> the patch.
> The only thing left to do is to consolidate DA903[045]_DVC macros:
> 

Mmm.... this looks a bit zigzag, and making the definition of DA90x_DVC()
too long (> 80 chars?), that's why it was originally written so.

DA9035 is actually very similar to DA9034 that doesn't even deserve a separate
name for (it does have a significant change in the analog frontend - but that's
out of AP control), so I basically don't bother invent a DA9035_DVC().

I have to admit that defining both DA9030_DVC() and DA9034_DVC() is a bit
redundant, but keeps the code in a little bit better shape.

