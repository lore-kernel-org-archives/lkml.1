Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbXECNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbXECNdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXECNdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:33:16 -0400
Received: from smtp007.mail.ukl.yahoo.com ([217.12.11.96]:39845 "HELO
	smtp007.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754076AbXECNdP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:33:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5Kf/onEI4EBOVVoZ23B6v5eFSSxOtIhuAC4e1uoMKooGH5BFIlSedbn9JlLwxHS2GlGEpP9mIsi6CMSkGCns5cStRl41IJ+cCxN9ZgXJ1Z6Kf5mpiQLUHahCwd15/v2GtQY6HjMk2eGr6zvPW24cnznrteJQJ2jc3PJgRtjsDrg=  ;
X-YMail-OSG: MLGQxqUVM1lTEHT5JMkOQ.x3SLnS.n10olCTzPN90.W4qFTtxkb9NcjC7_cJdwqWKtUFrEVEoVUWLxEZ1URqST_BCw1IFYA_INkChoJ9iiajCgSk
From: Blaisorblade <blaisorblade@yahoo.it>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 5/6] UML - Network and pcap cleanup
Date: Thu, 3 May 2007 15:32:43 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
References: <20070501182159.GA8363@c2.user-mode-linux.org>
In-Reply-To: <20070501182159.GA8363@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705031532.44157.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On martedì 1 maggio 2007, Jeff Dike wrote:
> [ Paolo - could you eyeball the globally valid MAC piece of this and
> see if you think it's OK? ]

Done, the patch can be accepted (I've not looked at the PCAP part). I've a 
note on the other fix there (the additional return).

> Some network device cleanup.
>
> When setup_etheraddr found a globally valid MAC being assigned to an
> interface, it went ahead and used it rather than assigning a random
> MAC like the other cases do.  This isn't really an error like the
> others, but it seems consistent to make it behave the same.
Fine, agreed. For this, you can add my Acked-by. Probably at that time MAC 
randomization wasn't implemented.

> We were getting some duplicate kfree() in the error case in
> eth_configure because platform_device_unregister frees buffers that
> the error cases following tried to free again.

This is due to patch:
"uml: drivers get release methods"
this could be useful to check whether other such changes are needed, by 
grepping for platform_device_unregister in exit paths, also for ubd driver.

That patch only fixed net_remove() and ubd_remove().
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
