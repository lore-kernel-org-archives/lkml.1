Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYGUWFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYGUWFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYGUWF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:05:26 -0400
Received: from stinky.trash.net ([213.144.137.162]:49337 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYGUWFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:05:25 -0400
Message-ID: <488507FB.9050101@trash.net>
Date: Tue, 22 Jul 2008 00:04:43 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4884F3D7.4070604@lwfinger.net>	<20080721.134608.75595942.davem@davemloft.net>	<4884F6E9.6090809@trash.net> <20080721.140120.135667045.davem@davemloft.net> <4884FA3F.70109@trash.net> <48850121.9090106@trash.net> <488504D9.5090100@lwfinger.net>
In-Reply-To: <488504D9.5090100@lwfinger.net>
Content-Type: multipart/mixed;
 boundary="------------080609000902030105010805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080609000902030105010805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Larry Finger wrote:
> Patrick McHardy wrote:
>>
>> This is what I was missing, we're setting a lockdep class
>> by default depending on dev->type. This patch combined
>> with yours should fix all addr_list_lock warnings.
>
> No cigar yet. I tried davem's patch first, then yours on top of his. I 
> still get both the recursive locking and the kernel warning.

Does this one earn me my cigar? :)



--------------080609000902030105010805
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/core/dev.c b/net/core/dev.c
index 2eed17b..371b1a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -259,7 +259,7 @@ static RAW_NOTIFIER_HEAD(netdev_chain);
 
 DEFINE_PER_CPU(struct softnet_data, softnet_data);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#ifdef CONFIG_LOCKDEP
 /*
  * register_netdevice() inits txq->_xmit_lock and sets lockdep class
  * according to dev->type

--------------080609000902030105010805--
