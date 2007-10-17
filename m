Return-Path: <linux-kernel-owner+w=401wt.eu-S935200AbXJQPgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200AbXJQPgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762333AbXJQPgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:36:00 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:53814 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762269AbXJQPf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AizgroOkwMXtQMmM6Sz8BrAUWMV73W8gVtr9FMt8FlYfMhmftXxQE45jzKYy4uL9Xnw+h9lyddGOIKsQxhX0/FNVeHOF8nrujdt0JDLwMzSAMuO09hIy943UH04UcGvLM4RocVtQO80rJzIcvfXdmhRu04dTJJ8gBqsMK3LVYPY=
Message-ID: <386072610710170835j20d88feej2b107c8e8b686e89@mail.gmail.com>
Date: Wed, 17 Oct 2007 23:35:49 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH try #4] Input/Joystick Driver: add support AD7142 joystick driver
Cc: bryan.wu@analog.com, "Andrey Panin" <pazke@donpac.ru>,
       "Roel Kluin" <12o3l@tiscali.nl>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20071017160702.3316fc24@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192605120.7920.15.camel@roc-laptop>
	 <20071017160702.3316fc24@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Bryan,
>
> On Wed, 17 Oct 2007 15:12:00 +0800, Bryan Wu wrote:
> > Subject: [PATCH try #4] Input/Joystick Driver: add support AD7142 joystick driver
>
> This driver is a good candidate for the new-style i2c infrastructure.
> Instead of letting i2c-core probe for the device on all available I2C
> buses, you would explicitly instantiate it from platform data. In
> practice this would mean:
> * Declare the ad7142 in platform data.
> * Call i2c_register_board_info() on that data.
> * In your ad7142 driver, implement .probe and .remove instead
>   of .attach_adapter and .detach_client.
>
I would like to rewrite it by using new-style i2c infrastructure.
But it will take some time. If I meet some problem, hope can get some advice
from you and the community.

> Of course this assumes that the underlying bus driver is also new-style
> ready (i.e. it uses i2c_add_numbered_adapter() instead of
> i2c_add_adapter()), and that you know in advance when the AD7142 is
> there or not. I hope this is the case?
>
Oh, currently i2c-bfin-twi driver is using the old-style code.

> Using a new-style i2c driver is especially important if the device
> can't be detected.
>
> Also see my i2c-related comments inline.
>

I will fix all the issues and try to pass our Blackfin AD7142 Joystick testcase.
and resubmit a patch.

Thanks
-Bryan

[!snip!]
