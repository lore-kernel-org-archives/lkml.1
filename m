Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZGBA6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZGBA6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZGBA6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:58:09 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:48954 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZGBA6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=btO6+TBsD8KL9nEgwx+ScU64+vfFvo02Y6Xy7+k+C8uzm5bs2aKy1lSmTQTW+ILxWi
         jXZ+OPwbxtpWXmz5HXygoSZtmw8UxqaXGUH3cjVhpgXnNknaQscmZgQpPXIWvb5uotZf
         B8xgaM13wmOtnhJ1rVw0U1GjsYHs0YfwW75k4=
MIME-Version: 1.0
In-Reply-To: <4A4B6B90.90006@atmel.com>
References: <1246012936-10812-1-git-send-email-nicolas.ferre@atmel.com>
	 <4A4B6B90.90006@atmel.com>
Date: Wed, 1 Jul 2009 17:58:10 -0700
X-Google-Sender-Auth: 60e30f4441f963d7
Message-ID: <e9c3a7c20907011758s3188881bqd4beae7192c28162@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] dmaengine: at_hdmac: new driver for the Atmel AHB 
	DMA Controller
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: maciej.sosnowski@intel.com, avictor.za@gmail.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 6:58 AM, Nicolas Ferre<nicolas.ferre@atmel.com> wrote:
> Hi,
>
> Just one question Dan (see below).
>
> Nicolas Ferre :
>> This AHB DMA Controller (aka HDMA or DMAC on AT91 systems) is availlable on
>> at91sam9rl chip. It will be used on other products in the future.
>
> [..]
>> +     /*
>> +      * The API requires that no submissions are done from a
>> +      * callback, so we don't need to drop the lock here
>> +      */
>> +     if (callback)
>> +             callback(param);
>
> Even if our dma controller does not seems to take advantage of
> dependency requests...
>
> ...should I add the
> dma_run_dependencies(txd);
> call here to improve conformance to dmaengine standards ?

That would be nice but it is not a strict requirement.

To me it just seems like leaving something for some future developer
to trip over when debugging why channel switching does not work with
this driver.  If you can guarantee that this driver will always be the
only dma_device driver in the system and that future products will not
add additional operation types then maybe it can be omitted.
Otherwise, the overhead of including the call should be negligible.

Regards,
Dan
