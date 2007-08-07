Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXHGNPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXHGNPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbXHGNP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:15:28 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56193 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758668AbXHGNP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:15:27 -0400
Message-Id: <1186492527.30132.1204156793@webmail.messagingengine.com>
X-Sasl-Enc: pcSzWhXCESIsvUf4btl+7PU/zH7FJl3+WiCp/+uP17tb 1186492527
From: "Adam M" <lkml@irotas.net>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Cc: linux-kernel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1186443467.11680.1204059001@webmail.messagingengine.com>
   <6CADE9C0-2EE3-4404-B33B-0941533933D2@mac.com>
Subject: Re: Creating virtual interface triggers an IGMPv3 Join to Multicast DNS
In-Reply-To: <6CADE9C0-2EE3-4404-B33B-0941533933D2@mac.com>
Date: Tue, 07 Aug 2007 09:15:27 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

Ah-hah, you nailed it right on the head. I unknowingly had Bonjour
running (must be installed by default on Fedora Core 3), which started a
process 'mDNSResponder'. I'm guessing that's the bugger that's fire off
these multicast joins.

Thanks for the tip!

-Adam


On Tue, 7 Aug 2007 00:30:36 -0400, "Kyle Moffett" <mrmacman_g4@mac.com>
said:
> On Aug 06, 2007, at 19:37:47, Adam M wrote:
> > Hi folks,
> >
> > For some reason, every time I create a virtual interface (using  
> > tun), the interface immediately generates an IGMPv3 Join packet for  
> > group 224.0.0.251, which (according to Google) is Multicast DNS.
> >
> > This packet is generated automatically and consistently. I'm  
> > wondering why this should be the case, and if it can be disabled.
> 
> You don't happen to be running "avahi" or one of the other Zeroconf/ 
> Bonjour/Rendezvous/$P2P_BUZZWORD_OF_THE_WEEK local-network-discovery  
> daemons, do you?  Most of those keep an eye out for new network  
> interfaces and automatically start pushing multicast packets down  
> them as soon as they appear, which is the most likely explanation for  
> what you are seeing; as opposed to a kernel issue.
> 
> Cheers,
> Kyle Moffett
> 
