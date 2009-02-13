Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbZBMA7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbZBMA7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbZBMA7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:59:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48522
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbZBMA7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:59:30 -0500
Date: Thu, 12 Feb 2009 16:59:24 -0800 (PST)
Message-Id: <20090212.165924.220333032.davem@davemloft.net>
To: clement.lecigne@netasq.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 4 bytes kernel memory disclosure in SO_BSDCOMPAT gsopt
 try #2
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090212123545.GA46788@clem1.netasq.com>
References: <20090212123545.GA46788@clem1.netasq.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clement LECIGNE <clement.lecigne@netasq.com>
Date: Thu, 12 Feb 2009 13:35:45 +0100

> In function sock_getsockopt() located in net/core/sock.c, optval v.val
> is not correctly initialized and directly returned in userland in case
> we have SO_BSDCOMPAT option set.
> 
> This dummy code should trigger the bug:
> 
> int main(void)
> {
> 	unsigned char buf[4] = { 0, 0, 0, 0 };
> 	int len;
> 	int sock;
> 	sock = socket(33, 2, 2);
> 	getsockopt(sock, 1, SO_BSDCOMPAT, &buf, &len);
> 	printf("%x%x%x%x\n", buf[0], buf[1], buf[2], buf[3]);
> 	close(sock);
> }
> 
> Here is a patch that fix this bug by initalizing v.val just after its declaration.

Applied, thank you.
