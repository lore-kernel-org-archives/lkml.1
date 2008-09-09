Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbYIIH7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbYIIH7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYIIH7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:59:15 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:50302 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYIIH7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=iMI4X6ctEcXfFbk6wtUG/+t+dzaJQztOxJZMfDdgYl5LXSABqB7quwY/gIGhsx6aVB
         7kzW1YCbhdfnluh5+oZMfG8QDdLS0CQ3qrkFFZJsc66XJLb9Z+bQo4XzKgTrtZ546/dl
         NjWH5cIWndQyc6Rg3HQM6JUxrvlywinqwtCe4=
Message-ID: <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
Date: Tue, 9 Sep 2008 08:59:11 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <20080909094438.6423b8ef@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50809010812i32168136qea538ba177b81446@mail.gmail.com>
	 <20080907123832.5ba79c12@mjolnir.drzeus.cx>
	 <5ff4a1e50809080628i65bd7c7blfac70659a9f9229c@mail.gmail.com>
	 <20080909092216.46a6eba1@mjolnir.drzeus.cx>
	 <5ff4a1e50809090034y3156427bpfac8a07674c3c844@mail.gmail.com>
	 <20080909094438.6423b8ef@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
> On Tue, 9 Sep 2008 08:34:27 +0100
> "Matt Fleming" <mattjfleming@googlemail.com> wrote:
>
>> 2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
>> > On Mon, 8 Sep 2008 14:28:00 +0100
>> > "Matt Fleming" <mattjfleming@googlemail.com> wrote:
>> >
>> >> You're right, I changed the patch accordingly (I also fixed the read
>> >> timeout path).
>> >>
>> >
>> > This still doesn't use the fields from the request structure. E.g. SDIO
>> > support is probably still broken here as it mandates a timeout of 1
>> > second for data transfers.
>> >
>>
>> What fields in the request structure? Are you talking about struct mmc_request ?
>
> Yup, timeout_ns and timeout_clks.
>

OK, just to be clear, where are those fields not used? They are used
in the new mmc_get_timeout() function.

I'm assuming SDIO should use the same logic as MMC for working out the
timeout value? Or is there an upper limit of 1 second on the timeout
for SDIO? I am not very confident in my understanding of the nuances
of SDIO. Also, I don't have any SDIO hardware so I can't test this
change (which is the reason I didn't change it in the first place).
