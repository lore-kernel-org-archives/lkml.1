Return-Path: <linux-kernel-owner+w=401wt.eu-S934756AbZJJTUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756AbZJJTUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934638AbZJJTUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:20:16 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:52391 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934621AbZJJTUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:20:14 -0400
Message-ID: <4AD0DE38.2010101@free.fr>
Date: Sat, 10 Oct 2009 21:19:20 +0200
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= <nicolas.2p.debian@free.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Jay Vosburgh <fubar@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net
Subject: Re: [Bonding-devel] [PATCH] net,	bonding: Add return statement in
 bond_create_proc_entry.
References: <b9df5fa10910091910u1b6bf14bg2781cb12c58b21f9@mail.gmail.com>
In-Reply-To: <b9df5fa10910091910u1b6bf14bg2781cb12c58b21f9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakib Mullick wrote:
> The function bond_create_proc_entry supposed to return int instead of void.
> And fixes the following compilation warning.
> 
> drivers/net/bonding/bond_main.c: In function `bond_create_proc_entry':
> drivers/net/bonding/bond_main.c:3393: warning: control reaches end of
> non-void function
> 
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linus/drivers/net/bonding/bond_main.c	2009-10-09 17:38:35.000000000 +0600
> +++ rakib/drivers/net/bonding/bond_main.c	2009-10-09 17:47:46.000000000 +0600
> @@ -3391,6 +3391,7 @@ static void bond_destroy_proc_dir(void)
> 
>  static int bond_create_proc_entry(struct bonding *bond)
>  {
> +	return 0;
>  }

This empty function is defined inside the else branch of an ifdef. The corresponding non-empty 
function always return 0 and no caller of this function use the returned value.

So I suggest to change the return type of this function from int to void, instead of adding a return 
0 into the empty one.

	Nicolas.

