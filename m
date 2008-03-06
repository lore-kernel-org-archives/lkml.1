Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbYCFPpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbYCFPpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbYCFPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:45:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:35215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177AbYCFPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:45:04 -0500
In-Reply-To: <47CFEE9D.1020300@tiscali.nl>
References: <47CFEE9D.1020300@tiscali.nl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <5adf51cc1df72cfd261e3c6e7bead312@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: paulus@samba.org, arnd@arndb.de, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] PPC: in celleb_show_cpuinfo() convert strncpy(x, y, sizeof(x)) to strlcpy 
Date: Thu, 6 Mar 2008 16:44:24 +0100
To: Roel Kluin <12o3l@tiscali.nl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch was not yet tested. Please confirm it's right.
> ---
> strncpy does not append '\0' if the length of the source string equals
> the size parameter, strlcpy does.

strlcpy() doesn't fill the rest of the array with zeroes, strncpy()
does.  This could matter (information leak, for example), although
I doubt it does here.

> -	strncpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
> +	strlcpy(celleb_machine_type, ptr, sizeof(celleb_machine_type));
>  	celleb_machine_type[sizeof(celleb_machine_type)-1] = 0;

That last statement makes the strncpy() case always zero-terminated,
so this patch isn't necessary.  Oh, and neither the old nor the new
code handles the case where the string doesn't fit (other than just
cutting it short); is that the wanted behaviour?


Segher

