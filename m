Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZBJB5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZBJB5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZBJB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:57:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56675
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbZBJB5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:57:20 -0500
Date: Mon, 09 Feb 2009 17:57:14 -0800 (PST)
Message-Id: <20090209.175714.70463534.davem@davemloft.net>
To: roel.kluin@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevice: ticks reaches 25, not 26.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4990AC93.3080906@gmail.com>
References: <4990AC93.3080906@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Date: Mon, 09 Feb 2009 23:22:11 +0100

> With while (tick++ < 25) { ... } ticks reaches 25, not 26.

Does it?

--------------------
#include <stdio.h>
int main(void)
{
	int i = 0;
	while (i++ < 25)
		;
	printf("%d\n", i);

	return 0;
}
--------------------
davem@sunset:~/src/GIT/linux-2.6$ gcc -O2 -o x x.c
davem@sunset:~/src/GIT/linux-2.6$ ./x
26
davem@sunset:~/src/GIT/linux-2.6$ 

I'm getting extremely tired of these "off by one" patches, to be
honest with you.
