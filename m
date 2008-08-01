Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYHARfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYHARfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHARfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:35:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbYHARfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:35:05 -0400
Message-ID: <48934926.2010200@zytor.com>
Date: Fri, 01 Aug 2008 10:34:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: x86 BIOS interface for partitioning and system serial number
 on SGI UV
References: <20080731195753.GB25715@sgi.com>
In-Reply-To: <20080731195753.GB25715@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:
> x86 BIOS interface for partitioning and system serial number on SGI UV

> -	if (!proc_mkdir("sgi_uv", NULL))
> +	if (!sgi_uv_dir)
> +		sgi_uv_dir = proc_mkdir("sgi_uv", NULL);
> +	if (!sgi_uv_dir)
>  		return -EINVAL;

This really seems more that it should belong in sysfs -- 
/sys/class/firmware presumably.

> +# define BIOS_CALL(result, a0, a1, a2, a3, a4, a5, a6, a7)		\
> +	do {								\
> +		/* XXX - the real call goes here */			\
> +		result.status = BIOS_STATUS_UNIMPLEMENTED;		\
> +		result.v0 = 0;						\
> +		result.v1 = 0;						\
> +	} while (0)

I have more than a little problem with submitting patches like this.  We 
have no way to judge the suitability of the coding or the interface with 
the "meat" of the driver stubbed out!

	-hpa
