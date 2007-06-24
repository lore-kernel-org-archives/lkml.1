Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXFXGL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXFXGL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 02:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXFXGLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 02:11:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54107
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753676AbXFXGLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 02:11:49 -0400
Date: Sat, 23 Jun 2007 23:12:07 -0700 (PDT)
Message-Id: <20070623.231207.44965284.davem@davemloft.net>
To: okir@lst.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Make skb_seq_read unmap the last fragment
From: David Miller <davem@davemloft.net>
In-Reply-To: <200706190956.26252.okir@lst.de>
References: <200706190956.26252.okir@lst.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Kirch <okir@lst.de>
Date: Tue, 19 Jun 2007 09:56:24 +0200

> From: Olaf Kirch <olaf.kirch@oracle.com>
> 
> Make skb_seq_read unmap the last fragment
> 
> Having walked through the entire skbuff, skb_seq_read would leave the
> last fragment mapped.  As a consequence, the unwary caller would leak
> kmaps, and proceed with preempt_count off by one. The only (kind of
> non-intuitive) workaround is to use skb_seq_read_abort.
> 
> This patch makes sure skb_seq_read always unmaps frag_data after having
> cycled through the skb's paged part.
> 
> Signed-off-by: olaf.kirch@oracle.com

Thanks for finding and fixing this bug.

Patch applied, thanks again Olaf.
