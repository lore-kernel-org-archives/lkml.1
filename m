Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbZBHQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbZBHQ7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 11:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbZBHQ7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 11:59:14 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:65261 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZBHQ7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 11:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MZUWeW6GL4+0FLkCQYBn4TvyiwzjQ6eydmxcX0zQ/ayWzdqJoj9qQuyE8PUoAU1L6L
         l+7MmD62/5vNJX2zTNmMzJ55gJODc+9EPiR0JTU+3/XarptLrkCLH+CFuEU/7bQa7Kgn
         THcz4XocByFgit9VXhxeFo/oC0oe9pEBOxLA0=
MIME-Version: 1.0
In-Reply-To: <200902080807.29237.david-b@pacbell.net>
References: <498F0004.1030709@gmail.com>
	 <200902080807.29237.david-b@pacbell.net>
Date: Sun, 8 Feb 2009 17:59:10 +0100
Message-ID: <25e057c00902080859w3d9973a1u1e73450d37e20459@mail.gmail.com>
Subject: Re: pxa2xx_spi: spi_bfin5xx: limit reaches -1 rather than 0
From: roel kluin <roel.kluin@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/8 David Brownell <david-b@pacbell.net>:
> On Sunday 08 February 2009, Roel Kluin wrote:
>> vi drivers/spi/pxa2xx_spi.c +919
>> vi drivers/spi/spi_bfin5xx.c +645
>>
>>         if (flush(drv_data) == 0) {
>>                 dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
>>                 message->status = -EIO;
>>                 giveback(drv_data);
>>                 return;
>>         }
>>
>> But with a postfix decrement limit reaches -1 rather than 0.
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

could you please review the patch at http://lkml.org/lkml/2009/2/8/72
instead? I initially overlooked two similar issues in the same file.

> Although, note that if the *actual* count mattered here,
> the correect patch would be to test "flush() < 0)" ...
> except when using a "do {...} while (--limit)" idiom.

True. You can also increase the limit with 1 when changing post- to
prefix for the while (--limit) {...} idiom.
