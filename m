Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbXIQIQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbXIQIQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXIQIQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:16:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:5438 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXIQIQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=iyQYP0A9o1H2dq+SthxiPaobb1R3OqOPbhe38c/9FOn0MhdjzhZ/Tehm9BqQIwrXocFE9W4ozJmj+ZbuvBq7h2CqbT4aIdXvhXYIrar3RIewE1DXcx60nLDnndk2uc3ZTaUbUmtdZ4UzB8QEx/mCbO6L95N0A/+ucE4AAG2Xdo8=
Message-ID: <46EE37EA.7020802@panasas.com>
Date: Mon, 17 Sep 2007 10:16:42 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: shinkoi2005a <shinkoi2005a@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: printk format "%4.4s"
References: <46EDD114.7010403@gmail.com>
In-Reply-To: <46EDD114.7010403@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 17, 2007, 2:57 +0200, shinkoi2005a <shinkoi2005a@gmail.com> wrote:
> Hi, all
> 
> I have a question about printk format.
> 
> Can printk format use "%4.4s"?

Yes it can.
The precision part of the format determines the max number
of characters to copy from the string.
The 4 byte signature array might not null terminated
so you must use the .4 in the format otherwise vsnprintf
might look over the buffer for the terminating '\0'.

> This format is used following source.
> 
> #############
> drivers/acpi/tables/tbinstal.c
>                 ACPI_ERROR((AE_INFO,
>                             "Table has invalid signature [%4.4s], must be SSDT, PSDT or OEMx",
>                             table_desc->pointer->signature));
> 
> ##############
> At least, my dmesg is buggy output like that..

Hmm, looks like you should believe the error messages
rather than blaming the code for buggy output ;-)

Like it says, the table seems corrupt, has invalid signature
and checksum.

> 
> ##############
> $ dmesg
> (snip)
> ACPI Warning (tbutils-0158): Incorrect checksum in table [  ^E礑 -  00, should b
> e F6 [20070126]
> ACPI Error (tbinstal-0134): Table has invalid signature [  ^E礑, must be SSDT, P
> SDT or OEMx [20070126]
> (snip)
> ##############
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

