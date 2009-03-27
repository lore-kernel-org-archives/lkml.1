Return-Path: <linux-kernel-owner+w=401wt.eu-S1754478AbZC0H3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbZC0H3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZC0H3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:29:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44803
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752531AbZC0H3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:29:32 -0400
Date: Fri, 27 Mar 2009 00:29:20 -0700 (PDT)
Message-Id: <20090327.002920.134973741.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_rose/x25: Sanity check the maximum user frame size
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090326215826.18836.86957.stgit@localhost.localdomain>
References: <20090326215826.18836.86957.stgit@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 26 Mar 2009 21:58:51 +0000

> Otherwise we can wrap the sizes and end up sending garbage.
> 
> Closes #10423
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Applied, but:

> -	/* Build a packet */
> +	/* Build a packet - the conventional user limit is 236 bytes. We can
> +	   do ludicrously large NetROM frames but must not overflow */
> +	if (len > 65536)
> +		return -EMSGSIZE;
> +	
   ^^^^^^^^^^^^^

please fix the tab monster :-) Or, alternatively, check the patch
either with GIT's automatic checks (or using checkpatch.pl if you
haven't eaten recently)

