Return-Path: <linux-kernel-owner+w=401wt.eu-S1750982AbXDLOtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982AbXDLOtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 10:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXDLOtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 10:49:55 -0400
Received: from smtp.osdl.org ([65.172.181.24]:45255 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbXDLOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 10:49:54 -0400
Message-ID: <461E470B.5060907@linux-foundation.org>
Date: Thu, 12 Apr 2007 07:49:47 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
Organization: Linux Foundation
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: udp checksum issue in netpoll mode.
References: <6d6a94c50704120331m36957148iae111ab7324c88c2@mail.gmail.com>
In-Reply-To: <6d6a94c50704120331m36957148iae111ab7324c88c2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li wrote:
> I think we discussed this issue before.
>
> The current checksum function doesn't consider the kind of packet
> which is padded to reach a specific minimum length. I believe that's
> the problem caused my test case failed. Is this issue fixed? Or is it
> acceptable if I make a patch not calculating this kind of packet?
>
> Thanks,
> -Aubrey
The caller should be trimming the packet and updating the hardware checksum
value (like the normal UDP path).
