Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYAQU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYAQU56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:57:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYAQU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:57:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbYAQU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:57:47 -0500
Date: Thu, 17 Jan 2008 21:57:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: left over fix for leak of early_ioremp
Message-ID: <20080117205738.GA6400@elte.hu>
References: <200801171245.35095.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801171245.35095.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

>  		    && (!max_entries || count++ < max_entries))
> -			if (handler(entry, table_end))
> +			if (handler(entry, table_end)) {
> +				acpi_os_unmap_memory(table_header, table_header->length);
>  				return -EINVAL;
> +			}

> +		acpi_os_unmap_memory(table, table->length);

>  		}
> +		dmi_iounmap(p, 0x10000);

thanks, applied.

	Ingo
