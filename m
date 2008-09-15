Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYIOJYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYIOJYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 05:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYIOJYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 05:24:25 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:48913 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYIOJYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 05:24:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HxgS3LqQaAb+ckRziUgafCX+Mr2/LbdE/mOLkFEEUnA9pucIbkNTXH9fbeOAL0e3nB
         VsTFwQ1siMvyZMf5o0hGd/dzWsvtYhCjiYdi0dYXj8UvRDHoVg7slJ1tYXqIQkpCDY0e
         15t4Nvlytz/T0rvs1y8rho+gWgIyEXbTmsVes=
Message-ID: <5ff4a1e50809150224o600fd9fhb29e986bdb618464@mail.gmail.com>
Date: Mon, 15 Sep 2008 10:24:22 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080915103821.2b618bba@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	 <20080909094438.6423b8ef@mjolnir.drzeus.cx>
	 <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	 <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	 <5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
	 <5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
	 <20080914154817.3d618e67@mjolnir.drzeus.cx>
	 <5ff4a1e50809150103v1e250e0x4192e2fe901750a6@mail.gmail.com>
	 <20080915103821.2b618bba@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/15 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> On Mon, 15 Sep 2008 09:03:41 +0100
> "Matt Fleming" <mattjfleming@googlemail.com> wrote:
>
>> Yeah it does, but the card pointer isn't copied to host->card. That
>> was the point I was trying to make above.
>
> I understood that, but you shouldn't be using host->card to begin with.
> Host drivers shouldn't be concerned with card specifics at all as the
> logic can sometimes be quite complex. All information the host drivers
> need should be in the request structure. If it isn't, then we need to
> fix the request structure, not change the drivers to start poking
> deeper into the MMC stack.
>

OK, I can see your point here. However, this is a completely different
change to my original patch. Would it not make more sense to queue my
original patch and then for me to write some patches to move all the
timeout info into the request structure?

> Looking further at the specs, this needs to be handled int the caller
> (i.e. mmc_send_cid() and mmc_send_csd()). The specs specify the
> timeouts used for those commands and they are actually different from
> the timeouts used elsewhere. IOW this could not be properly handled in
> some generic helper.
>

Again, this is a good idea but a different change to the patch I wrote
originally.

So, what I propose is this. Could you please queue my bug fix (I can
send the two patches again) and then I will begin working on the
generic patches to fix the issues that you've raised in this thread?
How does that sound?
