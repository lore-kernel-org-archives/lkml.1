Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYFGUny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYFGUny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYFGUnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:43:42 -0400
Received: from 1wt.eu ([62.212.114.60]:1530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYFGUnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:43:41 -0400
Date: Sat, 7 Jun 2008 22:43:25 +0200
From: Willy Tarreau <w@1wt.eu>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 00/50] 2.6.25.6 -stable review
Message-ID: <20080607204325.GJ5609@1wt.eu>
References: <20080520.143238.87085088.davem@davemloft.net> <BAY103-DAV11AE409F40D0878FC3A259B2B60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV11AE409F40D0878FC3A259B2B60@phx.gbl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:27:58PM +0200, Marco Berizzi wrote:
> David Miller wrote:
> 
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Date: Tue, 20 May 2008 17:25:11 +0800
> > 
> >> On Wed, May 14, 2008 at 10:19:57AM +0200, Marco Berizzi wrote:
> >> > 
> >> > I hope this helps.
> >> 
> >> OK found the problem, it was my fault after all :)
> >> 
> >> Dave, this patch needs to go into stable too.
> >> 
> >> [IPSEC]: Use the correct ip_local_out function
> >> 
> >> Because the IPsec output function xfrm_output_resume does its
> >> own dst_output call it should always call __ip_local_output
> >> instead of ip_local_output as the latter may invoke dst_output
> >> directly.  Otherwise the return values from nf_hook and dst_output
> >> may clash as they both use the value 1 but for different purposes.
> >> 
> >> When that clash occurs this can cause a packet to be used after
> >> it has been freed which usually leads to a crash.  Because the
> >> offending value is only returned from dst_output with qdiscs
> >> such as HTB, this bug is normally not visible.
> >> 
> >> Thanks to Marco Berizzi for his perseverance in tracking this
> >> down.
> >> 
> >> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > Applied and queued to -stable, thanks!
> 
> Hi David,
> 
> I don't see this patch in Chris 2.6.25.6 -stable review message.

Is it already in mainline ? (stable should only contain already merged
patches). It generally helps the stable team if you indicate the commit
id, as it's easier to "git show" than to "git log|grep".

Regards,
Willy

