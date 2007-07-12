Return-Path: <linux-kernel-owner+w=401wt.eu-S934489AbXGLNaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489AbXGLNaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 09:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764312AbXGLN3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 09:29:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:26414 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761839AbXGLN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 09:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uEvjiUFPr3tRMk8Kv/ppeTg8Afs384gkzs1J3r5smnCKtfKnjf7TMSKtbCHXHumXSBOIqGXcquNvlQOIqOC16mgWKQ9scsIbQJI9DmE9Eaa3+8nYQJt0j4HQy7m19E95u6sAQdjRPC/+63VeaZVFKhxz034o3kAG9lxi3bJPT20=
Message-ID: <d120d5000707120629n53f123ccs5a933c71c9a14542@mail.gmail.com>
Date: Thu, 12 Jul 2007 09:29:54 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit systems
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Chris Wright" <chrisw@sous-sol.org>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20070712124503.GA16633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070712124503.GA16633@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/07, Ingo Molnar <mingo@elte.hu> wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Subject: [patch] net/input: fix net/rfkill/rfkill-input.c bug on 64-bit systems
>
> this recent commit:
>
>  commit cf4328cd949c2086091c62c5685f1580fe9b55e4
>  Author: Ivo van Doorn <IvDoorn@gmail.com>
>  Date:   Mon May 7 00:34:20 2007 -0700
>
>     [NET]: rfkill: add support for input key to control wireless radio
>
> added this 64-bit bug:
>
>        ....
>        unsigned int flags;
>
>        spin_lock_irqsave(&task->lock, flags);
>        ....
>
> irq 'flags' must be unsigned long, not unsigned int. The -rt tree has
> strict checks about this on 64-bit so this triggered a build failure.
>

Yep, my fault.

> For -stable too i suspect.
>

I don't think anyone uses rfkill in mainline yet. People were asking
to add it so that they can develop against it but I guess I should
have waited for the real user before pushing rfkill to David...
ANyway, I see it is being used in wireless-dev so it is not completely
useless ;)

-- 
Dmitry
