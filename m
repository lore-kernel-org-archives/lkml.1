Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYIIJnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYIIJnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYIIJmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:42:55 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35523 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbYIIJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pKB1NElduA1qy/L26c9WDVenP2B0eARVPn6BfheQ1/QNP34Rk8jCmCq0LRbBKqzTQ4
         XFofV5VceN4jzE3szaULNLacvfpBW3rgxFEVB1+p44lyl0A8xjAjzPclui7ivr4PSlB8
         7gB8VsD5pBFDrWcmj4yokI//JKYG0IQhcqaOs=
Message-ID: <5ff4a1e50809090242ha576dcdmf82d1e9ec2204178@mail.gmail.com>
Date: Tue, 9 Sep 2008 10:42:53 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: Re: [RFC][PATCH] MMC: Use write timeout value as read from CSR
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
In-Reply-To: <5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
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
	 <5ff4a1e50809090059i2bcdb7ber8cae07128eea5a77@mail.gmail.com>
	 <20080909105513.5b8ceaaf@mjolnir.drzeus.cx>
	 <5ff4a1e50809090207o5846f5udf709eeda81653eb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/9 Matt Fleming <mattjfleming@googlemail.com>:
> 2008/9/9 Pierre Ossman <drzeus-mmc@drzeus.cx>:
>
>> Why do you have that part though? What case have you found where you
>> need the timeouts and do not have properly set timeout fields?
>>
>
> This check was put in place because the function was being called
> before the card structure was setup properly. I didn't actually work
> out the call path but it stopped the kmmcd thread oopsing :)
>

The stack trace where this check is needed is here,

mmc_get_timeout()
mmc_spi_readblock()
mmc_spi_request()
mmc_wait_for_req()
mmc_send_cxd_data()
mmc_send_csd()
mmc_attach_sd()

Maybe it would be a good idea to move the line at
drivers/mmc/core/mmc.c:447 up before the call to mmc_send_csd()? Then
it'd probably be possible to remove that !host->mmc->card check from
mmc_get_timeout().
