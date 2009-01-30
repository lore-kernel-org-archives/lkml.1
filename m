Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZA3KRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZA3KRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZA3KRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:34469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZA3KRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fjAdfsN5NHhnLD9cSyC5xpMRyI4DF1PFUq++9d0sXBEyeJgyPgoLN3q81s01oKmYvN
         6ccZYcY7xFOGpZfi9Ul3d3vAeQrSnUTqj1KOEk5+tQ2SJxDXnUwXNEwA0RiqODXyso8R
         6rYWE3AqPfiPBZv1g0SYkXhjWL3C6GVsr+r+0=
MIME-Version: 1.0
In-Reply-To: <20090130110555.116f747a@gondolin>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
	 <20090130110555.116f747a@gondolin>
Date: Fri, 30 Jan 2009 18:17:36 +0800
Message-ID: <d82e647a0901300217s73a6a295sa61232bac8c95115@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: kay.sievers@vrfy.org, greg@kroah.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/30 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Fri, 30 Jan 2009 10:31:42 +0800,
> tom.leiming@gmail.com wrote:
>
>
>>  /**
>> + * driver_wait_probe_done_and_dev_appear
>> + * wait until the probe sequence is finished _and_ the dev @name appears.
>> + *
>> + */
>> +void driver_wait_probe_done_and_dev_appear(char *name)
>> +{
>> +     pr_debug("%s: probe_count = %d\n", __func__,
>> +              atomic_read(&probe_count));
>> +
>> +     wait_event(probe_waitqueue, (atomic_read(&probe_count) == 0) &&
>> +               name_to_dev_t(name));
>
> probe_waitqueue is only woken at the end of really_probe(), not when
> whatever needs to be done to make the device available is done...

Yes.

If probing done does not mean the device is available, this patch should be
ignored or fixed further.

But polling is really not good, is there a approach to avoid the polling for
appearence of the root device?

Thanks!

>
>> +}
>> +/**
>>   * driver_probe_device - attempt to bind device & driver together
>>   * @drv: driver to bind a device to
>>   * @dev: device to try to bind to the driver
>



-- 
Lei Ming
