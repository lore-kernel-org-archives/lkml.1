Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbXFCRUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbXFCRUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 13:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbXFCRU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 13:20:28 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58703 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbXFCRU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 13:20:27 -0400
Date: Sun, 3 Jun 2007 19:18:48 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Beverley <andy@andybev.com>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@lists.netfilter.org>,
       Netfilter Mailing List <netfilter@lists.netfilter.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
In-Reply-To: <1180890022.6601.6.camel@andybev>
Message-ID: <Pine.LNX.4.61.0706031914120.10578@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr> <1180890022.6601.6.camel@andybev>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 3 2007 18:00, Andrew Beverley wrote:
>On Sun, 2007-06-03 at 13:12 +0200, Jan Engelhardt wrote:
>> Adds the connlimit match that has been in POM-NG for a long time.
>> 
>>     *	works with 2.6.22, xtables'ified and all that
>> 
>>     *	will request nf_conntrack_ipv4 upon load
>> 	(otherwise it hotdrops every packet - a glitch that goes back
>> 	to at least 2.6.20.2)
>
>Excellent! This has been at the back of my mind for a while.
>
>Is there any chance of getting UDP flows added as well as TCP
>connections?

I dare to say it's easy. The real problem is rather, that UDP is
connectionless, so for one, connlimit can, by definition of the word
'connectionless', not apply to UDP, though it is technically
possible. Second, because UDP "connections" "fly" (timeout after 30
seconds), just spewing one UDP packet out may kill another connection
(e.g. if you use connlimit in conjunction with DROP or REJECT).
What's more, UDP packets can be easily forged, much more than TCP, so
anyone on the same subtree (not subnet, because that's something
different) can send a bogus UDP packet and stop your connections from
working.
Let's see how to implement UDP counting...


	Jan
-- 
