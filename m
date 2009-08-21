Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZHUUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZHUUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932352AbZHUUX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:23:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbZHUUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:23:27 -0400
Message-ID: <4A8F0228.80805@zytor.com>
Date: Fri, 21 Aug 2009 13:23:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix build with older binutils and consolidate	 linker
 script
References: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
In-Reply-To: <4A8AEA1F0200007800010563@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 08:51 AM, Jan Beulich wrote:
>  
>  #define VSYSCALL_ADDR (-10*1024*1024)
> -#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
> -#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
> -                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
> +#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
> +#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
> +                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
>  

I'm missing something with this chunk... could you please explain?

	-hpa
