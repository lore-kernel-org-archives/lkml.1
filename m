Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYFPN1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYFPN1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbYFPN1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:27:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40655 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbYFPN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:27:37 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <32834312.1213622802513.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 16 Jun 2008 22:26:42 +0900 (JST)
To: balbir@linux.vnet.ibm.com
Subject: Re: Re: [PATCH 1/6] res_counter:  handle limit change
Cc: kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, menage@google.com,
       xemul@openvz.org, yamamoto@valinux.co.jp, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com
In-Reply-To: <48565CBA.2040309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <48565CBA.2040309@linux.vnet.ibm.com>
 <48562AFF.9050804@linux.vnet.ibm.com> <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com> <400765.1213607050433.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

>> Definitely No. I think counters which cannot be shrink should return -EBUSY
>> by shrink_usage() when it cannot do it. 
>
>Wouldn't that be all counters except for the memory controller RSS counter? I
>can't see anyone besides the memory controller supporting shrink_usage().
>
Slab_counter is a candidate. But ok, if everyone doesn't like this,
I'll abandon the whole and rewrite it as v3. 

And condidering your point, my high-low-watermark patch set should be
implemented within memcg and adding high/low to res_counter is too bad.
I'll change my plan. But res_counter is less useful rather than I thought of ;
)
Besides it doesn't support any feedbacks, it just restricts the access to para
meters.

BTW, I believe current res_counter's behavior to return success
at usage > limit case is very bad. I'd like to return -EBUSY.
How do you think ?
(And I also think res_counter_charge returns -ENOMEM is BUG. It should be
 -EBUSY.)

Thanks,
-Kame

