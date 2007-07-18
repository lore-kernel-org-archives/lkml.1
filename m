Return-Path: <linux-kernel-owner+w=401wt.eu-S937559AbXGRXnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937559AbXGRXnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937172AbXGRXgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:36:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:48701 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937153AbXGRXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:36:14 -0400
X-IronPort-AV: i="4.16,553,1175486400"; 
   d="scan'208"; a="35193385:sNHT24647266"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Date: Wed, 18 Jul 2007 19:39:46 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <20070718151617.fe6a2943.akpm@linux-foundation.org>
In-Reply-To: <20070718151617.fe6a2943.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181939.46910.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 18 Jul 2007 23:36:11.0800 (UTC) FILETIME=[6C9E3980:01C7C994]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
> 
> I'd suggest that any interface into here should be via function calls,
> not via direct access to printk internals: think up some nice
> copy_me_some_of_the_log_buffer() interface.

If so - I would still like to put it in:
 - ifdef CONFIG_EARLY_PRINTK
 - and define as __init

so that people don't use it when they shouldn't (when the kernel is up an 
running).

Something simple like - early_copy_log_buff(void *dest, size_t n) 

copies n bytes from log_buf to memory area dest. Returns number of bytes that 
could not be copied. Can find out how many bytes are in the log_buff by 
calling with zero size.

This is not destructive to existing interfaces (log_start and con_start are 
not updated/used). This should ensure that if booting does work - that normal 
messages come out the standard method.

Any other suggestions?

-Robin
