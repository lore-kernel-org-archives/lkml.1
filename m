Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZIJAsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZIJAsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZIJAsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:48:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZIJAsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:48:02 -0400
Message-ID: <4AA84BE7.9010304@zytor.com>
Date: Wed, 09 Sep 2009 17:44:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Chris Friesen <cfriesen@nortel.com>, Daniel Walker <dwalker@fifo99.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: SGU UV Add volatile to macros that access chipset
 registers
References: <20090909154246.GA26716@sgi.com> <1252512600.14793.125.camel@desktop> <20090909180110.GA10311@sgi.com> <1252519885.14793.135.camel@desktop> <4AA7F9E5.4070506@nortel.com> <20090909193829.GB10530@sgi.com>
In-Reply-To: <20090909193829.GB10530@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2009 12:38 PM, Jack Steiner wrote:
>  
>  static inline void uv_write_local_mmr8(unsigned long offset, unsigned char val)
>  {
> -	*((unsigned char *)uv_local_mmr_address(offset)) = val;
> +	*((volatile unsigned char *)uv_local_mmr_address(offset)) = val;
>  }
>  

Why aren't you simply using __writeb() here, and the other memory
accessors we already have in the other places?

	-hpa
