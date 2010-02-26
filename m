Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab0BZQMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:12:10 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:49375 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238Ab0BZQMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:12:07 -0500
MIME-Version: 1.0
In-Reply-To: <20100226.015420.66646406.davem@davemloft.net>
References: <20100226094941.GE4912@bicker> <20100226.015420.66646406.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Feb 2010 09:11:46 -0700
X-Google-Sender-Auth: 43d6424c8c63bc5d
Message-ID: <fa686aa41002260811p23c86396wcbcd4a32daf504b5@mail.gmail.com>
Subject: Re: [patch] of: check for IS_ERR()
To: David Miller <davem@davemloft.net>
Cc: error27@gmail.com, jeremy.kerr@canonical.com, afleming@freescale.com,
       jezz@sysmic.org, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 2:54 AM, David Miller <davem@davemloft.net> wrote:
> From: Dan Carpenter <error27@gmail.com>
> Date: Fri, 26 Feb 2010 12:49:41 +0300
>
>> get_phy_device() can return an ERR_PTR()
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>> ---
>> I don't have a cross compile environment set up so I can't even compile
>> test this.  :/  But err.h is included so it should be OK.
>
> It should return ERR_PTR() consistently.  Checking for both
> NULL and ERR_PTR() is undesirable.

Ugh.  This is why I dislike the ERR_PTR() pattern so much.  The
compiler cannot do any type checking and it is implemented
inconsistently.  You have to go look at the calling function to find
out what you're allowed to do with the return value.  ie. which test
do I use? (!ptr) or IS_ERR(ptr)?

It would be better if ERR_PTR() returned a structure or a union.  At
least that way the compiler would yell at you if the an ERR_PTR was
being returned.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
