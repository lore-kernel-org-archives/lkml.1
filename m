Return-Path: <linux-kernel-owner+w=401wt.eu-S1751248AbZHXB4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248AbZHXB4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZHXB4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:56:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60870
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbZHXB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:56:04 -0400
Date: Sun, 23 Aug 2009 18:56:17 -0700 (PDT)
Message-Id: <20090823.185617.36449822.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       acme@ghostprotocols.net
Subject: Re: [PATCH 1/1] NET: llc, zero sockaddr_llc struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <1250967535-30692-1-git-send-email-jirislaby@gmail.com>
References: <1250967535-30692-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sat, 22 Aug 2009 20:58:55 +0200

> sllc_arphrd member of sockaddr_llc might not be set. Zero sllc
> before copying it to the above layers.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

I know it seems arbitrary, but could you please memset() on the
structure instead of using an empty initializer so that it's
consistent with how all other ->getname() implementations deal with
this issue?

It's easier to audit that way.

Thanks.
