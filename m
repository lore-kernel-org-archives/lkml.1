Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXEDEzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXEDEzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 00:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXEDEzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 00:55:24 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:29211 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXEDEzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 00:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EHNLxWfL4og5Y/eFKbDggAOibEf+Dl9yFlbb6/MenQwAjRB4PKpItz09pz9mbJRX6BzyvQm6/6ybbwkYhfr6FkKgDOUkzL8jHX1teD4Yi9CJNquK0G39rYn/9ugQnwhYUJson4Kbp4IZaFKjnBGPur9uQ+HbWspRfQFF8iXFcfQ=
Message-ID: <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
Date: Fri, 4 May 2007 00:55:21 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Anton Vorontsov" <cbou@mail.ru>
Subject: Re: [PATCH 3/8] Universal power supply class (was: battery class)
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, "David Woodhouse" <dwmw2@infradead.org>,
       "Henrique de Moraes Holschuh" <hmh@debian.org>
In-Reply-To: <20070503213139.GC20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503213139.GC20067@zarina>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Anton Vorontsov <cbou@mail.ru> wrote:
> This class is result of "external power" and "battery" classes merge,
> as suggested by David Woodhouse. He also implemented uevent support.

Looks great. In particular, the policies you've chosen for the
attributes and units are very reasonable.

I'll gladly accept patches moving tp_smapi to this interface (or
eventually do it myself when I have time).


A few minor points:

> +#define POWER_SUPPLY_TECHNOLOGY_UNKNOWN 0
> +#define POWER_SUPPLY_TECHNOLOGY_NIMH    1
> +#define POWER_SUPPLY_TECHNOLOGY_LION    2
> +#define POWER_SUPPLY_TECHNOLOGY_LIPO    3

Might as well add NiCd (common in UPS).


> +#define POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN  0
> +#define POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL 1
> +#define POWER_SUPPLY_CAPACITY_LEVEL_LOW      2
> +#define POWER_SUPPLY_CAPACITY_LEVEL_NORMAL   3
> +#define POWER_SUPPLY_CAPACITY_LEVEL_HIGH     4
> +#define POWER_SUPPLY_CAPACITY_LEVEL_FULL     5

Should this be synthesized by the driver if the hardware gives only
quantitative values? If so, maybe provide some guidelines.


> +enum power_supply_type {
> +       POWER_SUPPLY_TYPE_BATTERY = 0,
> +       POWER_SUPPLY_TYPE_UPS,
> +       POWER_SUPPLY_TYPE_AC,
> +       POWER_SUPPLY_TYPE_USB,
> +};

How about dumb (non-USB) DC power? Any reason to distinguish it from AC?

  Shem
