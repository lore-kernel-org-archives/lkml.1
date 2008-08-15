Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYHOLJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYHOLJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYHOLJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:09:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:28482 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYHOLJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YwRLsrpeb3tNLbs6JRLtTlf0hj3s4CH6ij52jEVo7AuVisR37U3vJaYN+MeAPaKgJS
         nkyf5qw0P8HALTO83xTvf0QFw2MAXoJP98vTEPlOM40dN3UauetckTOnN8Ywgh3yHFQb
         3z7mRGNN3xkZPvUt/jGZTGHMf1Fvy9zgv8dkI=
Message-ID: <a4423d670808150409j6df13225o7434fc6c223913f7@mail.gmail.com>
Date: Fri, 15 Aug 2008 15:09:20 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Bootmem allocator broken
Cc: mpatocka@redhat.com, hannes@saeurebad.de, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080814.162519.181180629.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0808130845290.8416@hs20-bc2-1.build.redhat.com>
	 <20080813.202559.193705172.davem@davemloft.net>
	 <Pine.LNX.4.64.0808141855500.15262@hs20-bc2-1.build.redhat.com>
	 <20080814.162519.181180629.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/15 David Miller <davem@davemloft.net>:
> From: Mikulas Patocka <mpatocka@redhat.com>
> Date: Thu, 14 Aug 2008 19:11:19 -0400 (EDT)
>
> [ Adding Alexander back to the CC: as he is seeing this same
>  exact bug too, please keep him in the loop for testing. ]

>> This patch fixes it (kernels 2.6.27-rc2 and 2.6.27-rc3 boot ok after the
>> patch). Johannes, please review the patch and submit it to Linus.
>>
>> With the patch it tries to continue at the end of previous allocation only
>> if the previous allocation ended in the middle of the page.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>


It is working! Thanks a lot David and Mikulas!

alexb@sparky ~ $ zgrep LOCKDEP /proc/config.gz
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y
alexb@sparky ~ $ uname -a
Linux sparky 2.6.27-rc3-00171-gb635ace-dirty #3 PREEMPT Fri Aug 15
14:52:40 MSD 2008 sparc64 sun4u TI UltraSparc IIi (Sabre) GNU/Linux
