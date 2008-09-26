Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYIZSwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYIZSwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbYIZSw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:52:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIZSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:52:26 -0400
Message-ID: <48DD2F68.6000609@zytor.com>
Date: Fri, 26 Sep 2008 11:52:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joris van Rantwijk <jorispubl@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Inflation of vmlinux by linker on x86_64
References: <20080926124222.GA49837@xs4all.nl>
In-Reply-To: <20080926124222.GA49837@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joris van Rantwijk wrote:
>  #endif
> -			memcpy(dest,
> -			       output + phdr->p_offset,
> -			       phdr->p_filesz);
> +			src = output + phdr->p_offset;
> +
> +			/* order the copying to avoid overwriting */
> +			if ((direction == 1  && dest <= src) ||
> +			    (direction == -1 && dest > src)) {
> +				/* note: unlike standard memcpy, this one
> +				 * is safe to use when dest and src overlap.
> +				 */
> +				memcpy(dest, src, phdr->p_filesz);
> +			}
> +
>  			break;

Instead of adding a comment like this, we should simply rename it memmove().

Furthermore, we probably spend enough time copying that using a real 
memmove() implementation, using string instructions, would be good.

	-hpa
