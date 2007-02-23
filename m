Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbXBWBmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbXBWBmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:42:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbXBWBmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:42:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXBWBms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:42:48 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] free swap space when (re)activating page
To: Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 23 Feb 2007 02:44:16 +0100
References: <7Pk3X-bD-17@gated-at.bofh.it> <7QvgM-3aK-3@gated-at.bofh.it> <7QDeB-7KY-11@gated-at.bofh.it> <7QGc7-3ZB-13@gated-at.bofh.it> <7QGlP-4e1-11@gated-at.bofh.it> <7QHUO-6RS-5@gated-at.bofh.it> <7QJ9Y-mo-1@gated-at.bofh.it> <7QJk7-zW-51@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HKPTs-0005p5-IV@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:9b3b2cc444a07783f194c895a09f1de9
X-Provags-ID2: V01U2FsdGVkX1/SOXZfGwIqp1rW05O/qHAVDM3UdQ0zY406jW+0RtEnIc3xV0KnLUE/X79yd9S0lpkXBqzknBP3vDbm1+8ghlt69LA8R24OeFg9BsCH35ZVWg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> wrote:

+++ linux-2.6.20.noarch/mm/swap.c††††††††2007-02-20 06:44:17.000000000 -0500
@@ -420,6 +420,26 @@ void pagevec_strip(struct pagevec *pvec)

> +††††††††††††††††††††††††if (printk_ratelimit())
> +††††††††††††††††††††††††††††††††printk("kswapd freed a swap space\n");
> 

NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!

1) This message is a debug message! You forgot to set the printk level.

2) The message text is bad, the average log reader only knows swap files
   and pages in swapfiles. The first reaction will be like "WTF happened
   to my swap???". Thousands of admins will cry out in anguish trying to
   get the meaning of this message, and again cry out in wrath after they
   found out.

3) What should I do if I see this message? It's neither good, nor bad for
   me, nor is it in any way informative even if it were changed to be
   meaningfull. It's utterly useless! Let it be!

-- 
We are all born ignorant, but one must work hard to remain stupid.
        -- Benjamin Franklin

Friﬂ, Spammer: JEN-ersdiT@kowaZ.7eggert.dyndns.org
