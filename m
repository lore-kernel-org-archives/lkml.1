Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249Ab0ARDNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab0ARDNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452Ab0ARDNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:13:54 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48112
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327Ab0ARDNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:13:53 -0500
Date: Sun, 17 Jan 2010 19:13:59 -0800 (PST)
Message-Id: <20100117.191359.190417865.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sivakumar.subramani@neterion.com,
       ram.vepa@neterion.com, santosh.rastapur@neterion.com,
       sreenivasa.honnur@neterion.com, anil.murthy@neterion.com
Subject: Re: [PATCH] S2io: two branches the same in wait_for_cmd_complete()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B53284C.1090405@gmail.com>
References: <4B53284C.1090405@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Sun, 17 Jan 2010 16:10:04 +0100

> Regardless of the bit_state, the branches execute the same code.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/net/s2io.c |   13 +++----------
>  1 files changed, 3 insertions(+), 10 deletions(-)
> 
> Maybe something else was intended?
> this was introduced in commit 9fc93a41a1ad11

If you know the guilty commit, at least do the author(s) of commit
and/or the driver maintainer(s) the courtesy of CC:'ing them on
patches like this.

I've fixed this up here in my reply.

> diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
> index cc42186..0e353d6 100644
> --- a/drivers/net/s2io.c
> +++ b/drivers/net/s2io.c
> @@ -3415,16 +3415,9 @@ static int wait_for_cmd_complete(void __iomem *addr, u64 busy_bit,
>  
>  	do {
>  		val64 = readq(addr);
> -		if (bit_state == S2IO_BIT_RESET) {
> -			if (!(val64 & busy_bit)) {
> -				ret = SUCCESS;
> -				break;
> -			}
> -		} else {
> -			if (!(val64 & busy_bit)) {
> -				ret = SUCCESS;
> -				break;
> -			}
> +		if (!(val64 & busy_bit)) {
> +			ret = SUCCESS;
> +			break;
>  		}
>  
>  		if (in_interrupt())
