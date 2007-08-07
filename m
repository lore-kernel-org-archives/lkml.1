Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbXHGKbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbXHGKbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbXHGKbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:31:02 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:42740 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXHGKbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:31:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18104.18914.642724.933374@gargle.gargle.HOWL>
Date: Tue, 7 Aug 2007 06:30:58 -0400
To: Matt Keenan <tank.en.mate@gmail.com>
Cc: Kevin K <k_krieser@sbcglobal.net>, linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sending raw packets via PPP
In-Reply-To: Matt Keenan's message of 7 August 2007 09:46:51
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net>
	<18103.44797.529894.786033@gargle.gargle.HOWL>
	<E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net>
	<46B8317B.40305@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
From: James Carlson <carlsonj@workingcode.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Keenan writes:
> Kevin K wrote:
> > I'll give it a try to see whether packets sent to 255.255.255.255 can
> > make it to ppp with the IP address unchanged.

You should be able to make DHCP work by sending ordinary unicast UDP
packets to the peer.  There shouldn't be any need to hack around with
special broadcast addresses.

Use AF_INET, SOCK_DGRAM, and send away.

> You shouldn't need to run DHCP over PPP, PPP uses LCP to configure
> connections. I suspect the only time you would need to run DHCP over a
> PPP link is if you had a DHCP proxy run the request over the PPP link,
> but that sounds way more complicated than what you are looking for.

I don't think that DHCP over PPP is a bad idea at all, particularly so
with DHCPINFORM messages, which are stateless and don't involve any
sort of address assignment.

PPP is not designed to provide arbitrary client application layer
configuration.  The RFC 1877 nonsense is a Microsoft proprietary thing
that doesn't actually work very well -- see my book for a more
substantial list of its flaws.

In contrast, DHCP works everywhere, includes *far* more configuration
information (such as boot servers, print servers, SIP addresses,
domain names, and the like), and is easier to manage than cramming
things into PPP.

> Have
> a quick look at
> http://www.cisco.com/univercd/cc/td/doc/cisintwk/ito_doc/ppp.htm that
> should bring you up to speed on how PPP works. You will probably find
> that LCP does everything you need. If you really need some of the
> functionality of DHCP (such as setting up WINS servers et al) you might
> find that you need to hack a way to do this.

The existing pppd already supports the MS proprietary hacks for DNS
and WINS server addresses.  Since that's a dead end, you'll need DHCP
if you want to go further.

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
