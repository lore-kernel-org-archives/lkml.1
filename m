Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbZFMUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbZFMUMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbZFMUMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbZFMUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:12:08 -0400
Date: Sat, 13 Jun 2009 13:11:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: =?ISO-8859-7?Q?Re=3A_-git_tree_build_failure_#2=3A_drivers=2Fnet=2Fcnic=2Ec=3A2520=3A_error=3A_implicit_declaration_of_function_=A1=5F=5Fsymbol=5Fget=A2?=
In-Reply-To: <20090613062933.GA14034@elte.hu>
Message-ID: <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com> <20090613062933.GA14034@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Jun 2009, Ingo Molnar wrote:
>
> > I just posted a patch for this to netdev and it was acked by its maintainer.
> > Patch is below.
> 
> This solves the first build failure but there's still a second build 
> failure:
> 
>  drivers/net/cnic.c: In function ‘init_bnx2_cnic’:
>  drivers/net/cnic.c:2520: error: implicit declaration of function ‘__symbol_get’
>  drivers/net/cnic.c:2520: warning: assignment makes pointer from integer without a cast
>  make[1]: *** [drivers/net/cnic.o] Error 1
>  make: *** [drivers/net/cnic.o] Error 2
> 
> This too triggers with the config i sent. The patch below solves it 
> - but i havent done more testing.
> 
> 	Ingo
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/drivers/net/cnic.c b/drivers/net/cnic.c
> index 8d74037..49135cc 100644
> --- a/drivers/net/cnic.c
> +++ b/drivers/net/cnic.c
> @@ -25,6 +25,8 @@
>  #include <linux/delay.h>
>  #include <linux/ethtool.h>
>  #include <linux/if_vlan.h>
> +#include <linux/module.h>
> +

That makes no sense. 

Look at the first #include in the file - it already includes 
<linux/module.h>.

Why do we need to do it twice?

		Linus
