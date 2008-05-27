Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbYE0JEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbYE0JEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYE0JEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:04:21 -0400
Received: from bay0-omc1-s30.bay0.hotmail.com ([65.54.246.102]:34201 "EHLO
	bay0-omc1-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269AbYE0JEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:04:20 -0400
Message-ID: <BAY103-DAV6C9F43F9EA7F257FCFC20B2BD0@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <herbert@gondor.apana.org.au>, "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <BAY103-DAV20B0EEFFB30A41A8020C8B2CC0@phx.gbl><BAY103-DAV88950FC99CDE9EAAE27B2B2CE0@phx.gbl><20080520092511.GA9005@gondor.apana.org.au> <20080520.143238.87085088.davem@davemloft.net>
Subject: Re: [IPSEC]: Use the correct ip_local_out function
Date: Tue, 27 May 2008 11:04:08 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 27 May 2008 09:04:20.0262 (UTC) FILETIME=[A6387C60:01C8BFD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Tue, 20 May 2008 17:25:11 +0800
>
> > On Wed, May 14, 2008 at 10:19:57AM +0200, Marco Berizzi wrote:
> > >
> > > I hope this helps.
> >
> > OK found the problem, it was my fault after all :)
> >
> > Dave, this patch needs to go into stable too.
> >
> > [IPSEC]: Use the correct ip_local_out function
> >
> > Because the IPsec output function xfrm_output_resume does its
> > own dst_output call it should always call __ip_local_output
> > instead of ip_local_output as the latter may invoke dst_output
> > directly.  Otherwise the return values from nf_hook and dst_output
> > may clash as they both use the value 1 but for different purposes.
> >
> > When that clash occurs this can cause a packet to be used after
> > it has been freed which usually leads to a crash.  Because the
> > offending value is only returned from dst_output with qdiscs
> > such as HTB, this bug is normally not visible.
> >
> > Thanks to Marco Berizzi for his perseverance in tracking this
> > down.
> >
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Applied and queued to -stable, thanks!

Just a confirmation message that this bug has been fixed
(one week uptime).


