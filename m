Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZITWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZITWxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbZITWxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 18:53:51 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49108 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZITWxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 18:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q3AA6Ju5bhnxB7LdSuKmWK573ES8eEzHODvhQs2mLjmgvHUkktk/1YHs8ZHY9a/0FR
         FGqHFcfXNB7IrKMWvjPBiLnZr2ruOQvIc9s2F14xjFcRRNQwd4i7SwGffLaIWnEH7Ksa
         orOdNxccdT9KVlwcxeVEeetNGEdkGf74NGzgM=
MIME-Version: 1.0
In-Reply-To: <20090920211620.1c18d7fb@hyperion.delvare>
References: <4AB5DE1F.1020004@gmail.com>
	 <20090920211620.1c18d7fb@hyperion.delvare>
Date: Sun, 20 Sep 2009 16:53:53 -0600
Message-ID: <51f3faa70909201553y75cb9f8q8ab34e9659fe479b@mail.gmail.com>
Subject: Re: [lm-sensors] coretemp support for Core i5 CPU
From: Robert Hancock <hancockrwd@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 1:16 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Robert,
>
> On Sun, 20 Sep 2009 01:47:43 -0600, Robert Hancock wrote:
>> Trying to load the coretemp driver for CPU temperature monitoring on a
>> Core i5 750 CPU gives:
>>
>> coretemp: Unknown CPU model 1e
>> coretemp: Unknown CPU model 1e
>> coretemp: Unknown CPU model 1e
>> coretemp: Unknown CPU model 1e
>>
>> Looks like this model needs to be added to the list in
>> drivers/hwmon/coretemp.c. Though this doesn't really seem like a very
>> good approach as we'll keep having to update this driver whenever a new
>> CPU model gets released. Intel has a CPUID field that indicates if the
>> thermal sensor is supported: "The processor supports a digital thermal
>> sensor if CPUID.06H.EAX[0] = 1." We should likely be using this instead
>> of hard-coded CPU model checks..
>
> Supporting the digital thermal sensor is one thing, but it is totally
> insufficient. If you look at the coretemp driver, you'll see we need to
> figure out a number of calibration values which are model-dependent. So
> we will need to check this part before adding support for new CPU
> models anyway.

Well, I see there is the TCC activation temperature which the reading
is relative to, which is detected on the mobile CPUs via an MSR read,
so it would only be a problem if they changed this temperature on
other CPUs..

It might make sense to warn "unknown CPU model, temperature reading
may be suspect" or something, but I should think it should still load
as the temperature reading is likely still correct.
