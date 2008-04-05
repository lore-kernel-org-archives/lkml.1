Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYDERTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYDERTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYDERTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 13:19:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:60686 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYDERTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 13:19:05 -0400
Message-ID: <47F7B483.8090101@codemonkey.ws>
Date: Sat, 05 Apr 2008 12:18:59 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC 2/5] vringfd base/offset
References: <200804052202.09157.rusty@rustcorp.com.au> <200804052204.28518.rusty__10896.9346424148$1207397431$gmane$org@rustcorp.com.au>
In-Reply-To: <200804052204.28518.rusty__10896.9346424148$1207397431$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> It turns out the lguest (and possibly kvm) want the addresses in the
> ring buffer to only cover a certain part of memory, and be offset.
> 
> It makes sense that this be an ioctl.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>

<snip>

> @@ -208,12 +232,15 @@ int vring_get_buffer(struct vring_info *
>  		out_len = &dummy;
>  
>  	*in_len = *out_len = 0;
> -	
> -	if (unlikely(get_user(head, &vr->ring.avail->ring[head]) != 0))
> +
> +	if (unlikely(get_user(head, &vr->ring.avail->ring[vr->last_avail
> +							  % vr->ring.num])))

Why not & with vr->mask for the sake of consistency with the rest of the 
code.

Regards,

Anthony Liguori
