Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYGUXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYGUXPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYGUXPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:15:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44341
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbYGUXPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:15:17 -0400
Date: Mon, 21 Jul 2008 16:15:17 -0700 (PDT)
Message-Id: <20080721.161517.27161039.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: kaber@trash.net, mingo@elte.hu, ischram@telenet.be,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
From: David Miller <davem@davemloft.net>
In-Reply-To: <4885104A.2070201@lwfinger.net>
References: <488504D9.5090100@lwfinger.net>
	<488507FB.9050101@trash.net>
	<4885104A.2070201@lwfinger.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 21 Jul 2008 17:40:10 -0500

> Sorry :(
> 
> I used the davem patch, the second version of your first one, and your second 
> one. Both problems persist.
> 
> Still plugging away on bisection.

GIT bisecting the lockdep problem is surely going the land you on:

commit e308a5d806c852f56590ffdd3834d0df0cbed8d7
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jul 15 00:13:44 2008 -0700

    netdev: Add netdev->addr_list_lock protection.
    
    Add netif_addr_{lock,unlock}{,_bh}() helpers.
    
    Use them to protect operations that operate on or read
    the network device unicast and multicast address lists.
    
    Also use them in cases where the code simply wants to
    block calls into the driver's ->set_rx_mode() and
    ->set_multicast_list() methods.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

