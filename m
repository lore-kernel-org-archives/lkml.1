Return-Path: <linux-kernel-owner+w=401wt.eu-S1759515AbYENL3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515AbYENL3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYENL2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:28:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbYENL2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:28:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1210619142.24092.60.camel@brick>
References: <1210619142.24092.60.camel@brick>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/12] mn10300: use the common ascii hex helpers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 14 May 2008 12:28:47 +0100
Message-ID: <1533.1210764527@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison <harvey.harrison@gmail.com> wrote:

> @@ -1322,22 +1310,22 @@ static int gdbstub(struct pt_regs *regs, enum exception_code excep)
>  		*ptr++ = 'O';
>  		ptr = mem2hex(tbcberr, ptr, sizeof(tbcberr) - 1, 0);
>  
> -		hx = hexchars[(bcberr & 0xf0000000) >> 28];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x0f000000) >> 24];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x00f00000) >> 20];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x000f0000) >> 16];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x0000f000) >> 12];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x00000f00) >> 8];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x000000f0) >> 4];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> -		hx = hexchars[(bcberr & 0x0000000f)];
> -		*ptr++ = hexchars[hx >> 4];	*ptr++ = hexchars[hx & 0xf];
> +		hx = hex_asc_hi(excep >> 24);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_lo(excep >> 24);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_hi(excep >> 16);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_lo(excep >> 16);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_hi(excep >> 8);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_lo(excep >> 8);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_hi(excep);
> +		ptr = pack_hex_byte(ptr, hx);
> +		hx = hex_asc_lo(excep);
> +		ptr = pack_hex_byte(ptr, hx);

NAK.

You made the code now emit excep rather than bcberr.

David
