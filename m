Return-Path: <linux-kernel-owner+w=401wt.eu-S935189AbXLPSRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935189AbXLPSRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 13:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932916AbXLPSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 13:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763646AbXLPSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 13:17:14 -0500
Message-ID: <47656B9E.3040405@zytor.com>
Date: Sun, 16 Dec 2007 10:17:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: devzero@web.de
CC: linux-kernel@vger.kernel.org, Matt.Domsch@dell.com
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
References: <49015158@web.de>
In-Reply-To: <49015158@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
>         /* Query EDD information */
>  #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
> -       query_edd();
> +        printf("Probing EDD (query Bios for boot-device information)\n");
> +        printf("If boot hangs here, you may have a buggy Bios. Try edd=skipmbr or edd=off");
> +        query_edd();
> +        printf("\rOK                                                                       \n");
>  #endif

This is awfully verbose.

I'd prefer something like:

printf("Probing EDD BIOS... ");
query_edd();
printf("ok\n");

[or even "failed"...]

Also, you really should look for the "quiet" command-line option and 
squelch the message.

	-hpa
