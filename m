Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYIXTDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYIXTDt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYIXTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:03:41 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33702 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:03:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mt7iE4mnDqbljTfkSpVVJ+gJ7sQxNO+413Qx6LWIynAf4mQOZRgoy2BFCh62a8ioFN
         0kjAuoxfo4Zm1VLMgwJgvrVWHbErVGuJXu+YEoXzTugkZxO2VXV6AEy1Ox1Z6TxGKYUV
         vhxhxAVJiQ4F+gnkNxLvQ7YQcft02SI1DNc7g=
Message-ID: <3ae72650809241203o41b62a10m31377887d44fd05e@mail.gmail.com>
Date: Wed, 24 Sep 2008 12:03:39 -0700
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Drew Moseley" <dmoseley@mvista.com>
Subject: Re: [PATCH] Create PNP device attributes via dev_attrs field of struct device
Cc: ambx1@neo.rr.com, linux-kernel@vger.kernel.org
In-Reply-To: <48DA774A.9010206@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D95EA2.9040804@mvista.com>
	 <3ae72650809232159k20f19f2ele5acbc7ee77dfb65@mail.gmail.com>
	 <48DA774A.9010206@mvista.com>
X-Google-Sender-Auth: 5a938cb963695baa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 10:22, Drew Moseley <dmoseley@mvista.com> wrote:
> Kay Sievers wrote:
>>
>> Any reason not to assign it statically to pnp_bus_type at in
>> drivers/pnp/driver.c?

> Not really but since everything in the dev_attrs array is statically
> defined in interface.c it was simpler to implement it this way.  To
> assign it in driver.c, the array can be made non-static and an extern
> added in driver.c, or the array definition can be moved to driver.c and
> all the set and show functions be made non-static.  Is there a preference?

Yeah, it looks weird to mangle the bus_type values from a device
routine, and set the same value again and again with every device
creation. Just declare the array non-static, if moving the code around
between files does not allow a static declaration.

Thanks,
Kay
