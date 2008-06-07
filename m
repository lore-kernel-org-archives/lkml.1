Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYFGUXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYFGUXs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYFGUXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:23:38 -0400
Received: from bay0-omc2-s38.bay0.hotmail.com ([65.54.246.174]:59030 "EHLO
	bay0-omc2-s38.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752279AbYFGUXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:23:37 -0400
Message-ID: <BAY103-DAV11AE409F40D0878FC3A259B2B60@phx.gbl>
X-Originating-IP: [88.35.96.158]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>
References: <BAY103-DAV20B0EEFFB30A41A8020C8B2CC0@phx.gbl><BAY103-DAV88950FC99CDE9EAAE27B2B2CE0@phx.gbl><20080520092511.GA9005@gondor.apana.org.au> <20080520.143238.87085088.davem@davemloft.net>
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
Date: Sat, 7 Jun 2008 22:27:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-OriginalArrivalTime: 07 Jun 2008 20:23:36.0786 (UTC) FILETIME=[5D8BC320:01C8C8DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Tue, 20 May 2008 17:25:11 +0800
> 
>> On Wed, May 14, 2008 at 10:19:57AM +0200, Marco Berizzi wrote:
>> > 
>> > I hope this helps.
>> 
>> OK found the problem, it was my fault after all :)
>> 
>> Dave, this patch needs to go into stable too.
>> 
>> [IPSEC]: Use the correct ip_local_out function
>> 
>> Because the IPsec output function xfrm_output_resume does its
>> own dst_output call it should always call __ip_local_output
>> instead of ip_local_output as the latter may invoke dst_output
>> directly.  Otherwise the return values from nf_hook and dst_output
>> may clash as they both use the value 1 but for different purposes.
>> 
>> When that clash occurs this can cause a packet to be used after
>> it has been freed which usually leads to a crash.  Because the
>> offending value is only returned from dst_output with qdiscs
>> such as HTB, this bug is normally not visible.
>> 
>> Thanks to Marco Berizzi for his perseverance in tracking this
>> down.
>> 
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Applied and queued to -stable, thanks!

Hi David,

I don't see this patch in Chris 2.6.25.6 -stable review message.

