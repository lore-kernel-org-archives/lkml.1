Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXHGRAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXHGRAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758989AbXHGRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:00:06 -0400
Received: from smtp120.sbc.mail.re3.yahoo.com ([66.196.96.93]:21863 "HELO
	smtp120.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758573AbXHGRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:00:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:In-Reply-To:References:Mime-Version:Content-Type:Message-Id:Cc:Content-Transfer-Encoding:From:Subject:Date:To:X-Mailer;
  b=LrRk9JzyWjzMLjwcpaPiEfAF82rlXjgDMmb7r7XiqlDdGHiM9vorsd1QWqCBwt6IaePwQvDiKSd7WqCMxrmkL6l8BdOlTes50j5h5IuQupBaaZTZA1XRQXV+aESLytU4Fuooe64m9tkT3RZCtO+eMLjprbG+b/3c9HF35np9zFA=  ;
In-Reply-To: <18104.18914.642724.933374@gargle.gargle.HOWL>
References: <35B9865F-38B4-4603-A2B7-F4ABACE5520F@sbcglobal.net> <18103.44797.529894.786033@gargle.gargle.HOWL> <E210D1E9-9265-48EE-91BB-E6027547F01E@sbcglobal.net> <46B8317B.40305@gmail.com> <18104.18914.642724.933374@gargle.gargle.HOWL>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4667B355-6DF5-469D-90F0-3070A9666E42@sbcglobal.net>
Cc: Matt Keenan <tank.en.mate@gmail.com>, linux-ppp@vger.kernel.org,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kevin K <k_krieser@sbcglobal.net>
Subject: Re: sending raw packets via PPP
Date: Tue, 7 Aug 2007 11:53:16 -0500
To: James Carlson <carlsonj@workingcode.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7, 2007, at 5:30 AM, James Carlson wrote:

> Matt Keenan writes:
>> Kevin K wrote:
>>> I'll give it a try to see whether packets sent to 255.255.255.255  
>>> can
>>> make it to ppp with the IP address unchanged.
>
> You should be able to make DHCP work by sending ordinary unicast UDP
> packets to the peer.  There shouldn't be any need to hack around with
> special broadcast addresses.
>
> Use AF_INET, SOCK_DGRAM, and send away.
>
>> You shouldn't need to run DHCP over PPP, PPP uses LCP to configure
>> connections. I suspect the only time you would need to run DHCP  
>> over a
>> PPP link is if you had a DHCP proxy run the request over the PPP  
>> link,
>> but that sounds way more complicated than what you are looking for.
>
> I don't think that DHCP over PPP is a bad idea at all, particularly so
> with DHCPINFORM messages, which are stateless and don't involve any
> sort of address assignment.
>
> PPP is not designed to provide arbitrary client application layer
> configuration.  The RFC 1877 nonsense is a Microsoft proprietary thing
> that doesn't actually work very well -- see my book for a more
> substantial list of its flaws.
>
> In contrast, DHCP works everywhere, includes *far* more configuration
> information (such as boot servers, print servers, SIP addresses,
> domain names, and the like), and is easier to manage than cramming
> things into PPP.
>
>> Have
>> a quick look at
>> http://www.cisco.com/univercd/cc/td/doc/cisintwk/ito_doc/ppp.htm that
>> should bring you up to speed on how PPP works. You will probably find
>> that LCP does everything you need. If you really need some of the
>> functionality of DHCP (such as setting up WINS servers et al) you  
>> might
>> find that you need to hack a way to do this.
>
> The existing pppd already supports the MS proprietary hacks for DNS
> and WINS server addresses.  Since that's a dead end, you'll need DHCP
> if you want to go further


In my case, I'll be connected to a router using PPP, and it is  
supposed to forward DHCP requests out to the broader network.  I will  
then have to choose between DHCP servers based on some extended  
options such as location, software version, etc.

If I don't have an IP address yet, I am supposed to generate a random  
IP address in the 10.x.x.x range for use long enough until I accept  
an offer.   It would obviously have been easier for me if the router  
could run the dhcp client, and configured my IP address via PPP.

Since no one has been able to inform me that raw mode is usable via  
PPP, that leaves me with some of the other suggestions, such as  
sending broadcast DGRAMs, or some other possibilities I've thought of  
since yesterday, one of which may work, which involves using iptables.

I have to have a fallback solution since the equipment is not yet  
available to test with.   So I'm going by requirements of how it is  
supposed to work now.

Thanks,
Kevin
