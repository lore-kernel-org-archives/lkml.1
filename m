Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbXLSNSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbXLSNSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXLSNSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:18:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:15564 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbXLSNSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Kcg1MT3OS+hbsbeG8QBmd4RYXN05SoX5MsFIOTF95B+PU8PCFUsp+uKHJ7ITcSFZgg1SLS99Vmj0nH8y46uKawlyhDAU4+LcNC+ajVSSzMp+WaTNm7AUgS0euLgstQbceDiNwaCCzXN+W159cGRmKAmq0DI3a9tm6wiHt3wuIaM=
Message-ID: <3efb10970712190518x384f06e7q39f8fd2a53e50d60@mail.gmail.com>
Date: Wed, 19 Dec 2007 14:18:18 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071219141100.7384aff9@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
	 <20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
	 <3efb10970712190450p64d4e7a2k7b80d47349be9570@mail.gmail.com>
	 <20071219141100.7384aff9@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: bc3acc406c4a6534
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> Hrm. We probably need to lock while updating icount. That's a problem
> since we do that from the tx interrupt handler...and I don't suppose we
> want to move most of the atmel_tx_chars() code into the tasklet too...?

I do not see a reason why not moving transmit to a tasklet. It is only
time critical to read in time. If the transmit is postponed for a
while, it will only slow down transmission, while not reading in time
results in lost data.

Kind Regards,

Remy
