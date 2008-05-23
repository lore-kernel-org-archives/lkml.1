Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYEWPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYEWPA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbYEWPAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:00:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40082 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbYEWPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:00:10 -0400
X-Sasl-enc: gsPn3RCja40fRscqDD1zLLsJOdCFrvXnMbYxbkdLcbAJ 1211554807
Message-ID: <4836DBF3.1030307@ladisch.de>
Date: Fri, 23 May 2008 17:00:03 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Haroldo Gamal <gamal@alternex.com.br>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/3] firmware: allow firmware files to be built into kernel
 image
References: <1211550282.28967.8.camel@pmac.infradead.org>
In-Reply-To: <1211550282.28967.8.camel@pmac.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> +	/* Built-in firmware blobs */					\
> +	.builtin_fw        : AT(ADDR(.builtin_fw) - LOAD_OFFSET) {	\
> +		VMLINUX_SYMBOL(__start_builtin_fw) = .;			\
> +		*(.builtin_fw)						\
> +		VMLINUX_SYMBOL(__end_builtin_fw) = .;			\
> +	}								\
> +									\

Most drivers, when built as a module, would want their firmware images
to be in the module and not in the kernel image.

This would require some (un)register_builtint_firmware() function.


Regards,
Clemens
