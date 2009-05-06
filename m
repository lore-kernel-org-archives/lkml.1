Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbZEFVWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbZEFVWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZEFVW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:22:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945AbZEFVW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:22:28 -0400
Date: Wed, 6 May 2009 14:19:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Winston.Austria@lsi.com
Subject: Re: [PATCH 3/10] scsi: megaraid_sas - Add Poll Wait mechanism to
 MegaRAID SAS driver (PART-II)
Message-Id: <20090506141904.15f70697.akpm@linux-foundation.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C43@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
	<4B6A08C587958942AA3002690DD4F8C354F61C43@cosmail02.lsi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009 18:41:45 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> @@ -3645,6 +3657,12 @@ static int __init megasas_init(void)
>                                   &driver_attr_release_date);
>         if (rval)
>                 goto err_dcf_rel_date;
> +
> +       rval = driver_create_file(&megasas_pci_driver.driver,
> +                               &driver_attr_support_poll_for_event);
> +       if (rval)
> +               goto err_dcf_support_poll_for_event;

This goto will be taken if the file wasn't successfully added.

>         rval = driver_create_file(&megasas_pci_driver.driver,
>                                   &driver_attr_dbg_lvl);
>         if (rval)
> @@ -3662,6 +3680,11 @@ err_dcf_poll_mode_io:
>  err_dcf_dbg_lvl:
>         driver_remove_file(&megasas_pci_driver.driver,
>                            &driver_attr_release_date);
> +
> +err_dcf_support_poll_for_event:
> +       driver_remove_file(&megasas_pci_driver.driver,
> +                       &driver_attr_support_poll_for_event);

And we then try to remove something which isn't there.
