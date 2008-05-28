Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYE1Mqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYE1Mqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 08:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYE1MqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 08:46:25 -0400
Received: from 1wt.eu ([62.212.114.60]:1296 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbYE1MqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 08:46:24 -0400
Date: Wed, 28 May 2008 14:45:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Cc: Matthias Cramer <matthias.cramer@interway.ch>,
       James Chapman <jchapman@katalix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Wired behaviour with IPv6 over PPP
Message-ID: <20080528124553.GA3252@1wt.eu>
References: <48341C0B.7010003@interway.ch> <20080522014959.0f6191aa.akpm@linux-foundation.org> <48354318.60202@katalix.com> <4835C40B.60603@interway.ch> <20080524042911.GE6749@1wt.eu> <483D2D11.9080803@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <483D2D11.9080803@plouf.fr.eu.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 28, 2008 at 11:59:45AM +0200, Pascal Hambourg wrote:
> Hello all,
> 
> Willy Tarreau a écrit/wrote :
> >On Thu, May 22, 2008 at 09:05:47PM +0200, Matthias Cramer wrote:
> >
> >>James Chapman wrote:
> >>
> >>>Andrew Morton wrote:
> >>>
> >>>>On Wed, 21 May 2008 14:56:43 +0200 Matthias Cramer
> >>>><matthias.cramer@interway.ch> wrote:
> >>>>
> >>>>>I have a very wired behaviour when doing IPv6 over PPPoE.
> >>>>>
> >>>>>The situation:
> >>>>>
> >>>>>A linux box connected to a DSL Modem, on the other side is a Cisco
> >>>>>LNS which terminates the PPP session (actually L2TP).
> >>>>>I have control over both ends.
> >>>>>
> >>>>>When I have net.ipv6.conf.all.forwarding set to 0 then the ppp
> >>>>>Interface gets a IPv6 address from the Cisco via IP6CP.
> >>>>>When I have net.ipv6.conf.all.forwarding set to 1 them the ppp
> >>>>>Interface does not get an address, it has only a normal link local
> >>>>>address.
> 
> AFAIK IPV6CP/PPP only allows to negotiate link local addresses.

right.

> So I 
> guess the global address and default route is assigned by another 
> mechanism, maybe stateless autoconfiguration using router advertisement, 
> although I was not aware it could be used on a PPP link because of the 
> absence of MAC address. Enabling global forwarding 
> (net.ipv6.conf.all.forwarding=1) disables stateless autoconfiguration 
> (see ip-sysctl.txt in kernel documentation) on all interfaces. I believe 
> this is consistent with the observed behaviour.
> 
> >>>>>When I start the ppp session with forwarding set to 0 I can ping out
> >>>>>and there exists a default route to ppp0 , then I switch forwarding to 
> >>>>>1
> >>>>>the default route disappears and therefore routing does not work any
> >>>>>longer.
> 
> I have read reports about this. I guess the logic is that enabling 
> forwarding turns the box into a router, so the default route learned 
> from another router's advertisements by autoconfiguration should be 
> deleted. Even the autoconfigured global address will eventually expire.
> 
> >Well, at least it has been working for years in kernel 2.4 for me with
> >pppd 2.4.2b3 to 2.4.4 (I've not upgraded my firewall to 2.6 yet). So
> >it has definitely been working at some point.
> 
> What exactly has been working ?

Sorry, I understood that IPv6 addresses got lost when IP forwarding was
set to 1, which sounded strange to me. I've re-read the original mail
more carefully and noticed that it was _autoconfiguration_ which does not
work. For this, I don't know as I don't use it. My bad.

> PS : Willy, do you plan to backport the security fix for the sit module 
> from 2.6.25.3 into 2.4 ?

Yes, any security fix must be backported when appropriate. I just don't
remember about this one, maybe I missed it. Care to send a pointer to
the commit in 2.6 ?

Thanks,
Willy

