Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYIJUS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYIJUS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYIJUSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:18:39 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38320 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYIJUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wIgiHJVNG0LbEpmzErFJ7hls/LULGzxL+Xh/wpNHJ9MXOaPir9wPMTrECyj969fb7a
         vabE5o+nQALckCRfT5PhiTvrKDskCNkrXH3Ff9DCqI4iKSHjdQ3zEOZHl3K1hVmlpjbM
         aVmtvrlO3J4Amk/W8YZsjgB7aigrXQTN3/LXw=
Message-ID: <43e72e890809101318o771100f0jcac9bbea6b863ccb@mail.gmail.com>
Date: Wed, 10 Sep 2008 13:18:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Marcel Holtmann" <holtmann@linux.intel.com>
Subject: Re: [PATCH 1/2 v6] cfg80211: Add new wireless regulatory infrastructure
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1221070650.13336.20.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221027589-19203-1-git-send-email-lrodriguez@atheros.com>
	 <1221027589-19203-2-git-send-email-lrodriguez@atheros.com>
	 <1221070650.13336.20.camel@californication>
X-Google-Sender-Auth: 9652af5562d0139a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:17 AM, Marcel Holtmann
<holtmann@linux.intel.com> wrote:
> Hi Luis,
>
>> This adds the new wireless regulatory infrastructure. The
>> main motiviation behind this was to centralize regulatory
>> code as each driver was implementing their own regulatory solution,
>> and to replace the initial centralized code we have where:
>>
>> * only 3 regulatory domains are supported: US, JP and EU
>> * regulatory domains can only be changed through module parameter
>> * all rules were built statically in the kernel
>>
>> We now have support for regulatory domains for many countries
>> and regulatory domains are now queried through a userspace agent
>> through udev allowing distributions to update regulatory rules
>> without updating the kernel.
>>
>> Each driver can regulatory_hint() a regulatory domain
>> based on either their EEPROM mapped regulatory domain value to a
>> respective ISO/IEC 3166-1 country code or pass an internally built
>> regulatory domain. We also add support to let the user set the
>> regulatory domain through userspace in case of faulty EEPROMs to
>> further help compliance.
>
> thanks for the write-up and examples. I like it a lot and gives driver
> maintainers a nice understanding what to do.

Thanks :)

> While reading through it, I came to think about regulatory_hint(). So is
> there a use case where would give it the alpha2 code and the domain
> itself at the same time? If not, then it would make more sense to split
> this into two functions.

Nope, you either pass an alpha2 or an rd domain which is built by you
(and in that rd structure you can set the alpha2 to your iso3166
alpha2 or "99" if unknown).

> Maybe something regulatory_alpha2_hint() and
> regulatory_domain_hint(). Just a thought.

That's how I had it originally but decided to condense it to one
routine since as you could see they pretty much do the same thing
except the case where the rd is provided it calls set_regdom().
Setting it back to use two routines if fine by me too. What is better?
Can we just get this merged and then we can flip it around if
necessary? :) I'm tired of carrying this around.

  Luis
