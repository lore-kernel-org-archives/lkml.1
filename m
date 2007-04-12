Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbXDLObJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbXDLObJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbXDLObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:31:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:22366 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXDLObH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=RvKn+F1SlqFkb79w0JVLPh/bRHGf0O58NPshDSYtqHzid0KTywigaSZOfZSE0s07DwzjqEe1NWvjoxdJ+GvWucZ1g1OI+B5T3+iSw8AW+ADYpCOtCgyq/ohwqclwImjQyTFmybj+zCFLubIdHBtGCvR3pNDgou2HCl9N0cnumf0=
Date: Thu, 12 Apr 2007 17:31:16 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1177494873.20070412173116@gmail.com>
To: Juergen Schindele <schindele@nentec.de>
CC: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] gpiodev - API definitions
In-Reply-To: <200704110847.01107.schindele@nentec.de>
References: <774343545.20070411003058@gmail.com> <200704110847.01107.schindele@nentec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Juergen,

Wednesday, April 11, 2007, 9:47:01 AM, you wrote:

> Am Dienstag, 10. April 2007 23:30 schrieb Paul Sokolovsky:
>> Hello linux-arm-kernel,
>>
>> GPIODEV API: Core API definitions. Provided are:
>> 1. struct gpiodev_ops which must be included into platform_data structure
>> of a device which will provide GPIODEV API; driver for a device must
>> initialize this structure.
>> 2. Structural definition of generalized GPIO identifier (struct gpio).
>> 2. Set of API calls for clients. This fully follow Generic GPIO API
>> naming and semantics, except that they have "gpiodev" prefix and
>> accept struct gpio instead of integer gpio identifiers.
>>
>>
[]
>> +/* API functions */
>> +
>> +static inline int gpiodev_get_value(struct gpio *gpio)
>> +{
>> +       struct gpiodev_ops *ops = gpio->gpio_dev->dev.platform_data;

> wouldn't it be more sure to verify if xxx function is NOT null
> before using it ?? Perhaps something like that
>              BUG_ON(!ops->get);

  GPIODEV is considered to be low-level one and critical for speed, so
all method pointers assumed to be set properly. In particular, if some
operation is not available for a device (say, GPI/GPO case), a method
must be set to a stab function.

  BUG_ON would be acceptable, as it can be compiled out based on
CONFIG setting, but as was pointed out, doesn't add much into picture
anyway.

  But I'd be happy to add comment to struct gpiodev_ops declaration
about the described method constraints, thanks for comment.

[]


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

