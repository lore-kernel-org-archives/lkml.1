Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYIZWpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYIZWpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYIZWo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:44:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50111 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYIZWo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O+WbDONWO55psjxr7dna76SSZR7sjm5pOrwaT0ZRsonLhyY+zIVX5DclGyzbbcT6bN
         s3Oopa2gecIHPbidnC/voaXaXuH64UASIrJSkLBfg43YDexIWCNKDJg+PhsyicR4/hay
         4wHNJwRCHKV6nJ2UmCxy4cjrBwEs19K3QGEjk=
Message-ID: <43e72e890809261544v466f0c67o339c3e45c68eaf3e@mail.gmail.com>
Date: Fri, 26 Sep 2008 15:44:55 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Getting country alpha2 on network manager and using it for crda
Cc: linux-wireless <linux-wireless@vger.kernel.org>, "Jouni Malinen" <j@w1.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1222440218.19895.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
	 <1222440218.19895.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 7:43 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2008-09-26 at 00:24 -0700, Luis R. Rodriguez wrote:
>> So since this may not happen for a while I figure I can give a shot.
>> But I'm curious where we should get our country alpha2 from? Does LSB
>> define a country has to be somewhere? Maybe the locale? Timezone?
>> Anyway, in the end the user should be able to change the country too.
>>
>> I'm thinking to start by just letting the user pick a country for now.
>> We can figure out where the hell it gets the country by default later
>> but if you have ideas that'd be great. It seems reasonable to ask for
>> this upon installation time (?)
>
> My suggestion: use the current timezone as a fallback unless the user
> has specified the locale somewhere.

Can this tell us the alpha2 they are in reliably? Is the locale
targeted for language only or can we use it for real geographical
localization as well?

Another neat idea is if a Linux has a GPS device for it to get an
alpha2 based on its coordinates and use that but I guess that can be
added later, and I guess you would need to be outdoors too.

> That can obviously be done in NM or
> lower, ideally we delegate this sort of thing to the supplicant and just
> pass the alpha2 when NM adds the interface to the supplicant.

Hm, I suppose it then depends on where this can be pulled from. So
from what you are suggesting NM would only use the alpha2 for
informational purposes?

What I was thinking too is to be able to let the nm-applet let you
select a country too, what do you think?

> The
> addInterface() call args are just a dict, so it would be trivial to add
> another item in that dict for country code.  Since the country code is
> global to the machine it's probably something we should just store in
> the system settings service,

That would be good indeed. Anyone know if LSB has a place for such a
thing? Do we just define one?

> and it's also something that probably
> requires privileges to change.

Yes, absolutely.

  Luis
