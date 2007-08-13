Return-Path: <linux-kernel-owner+w=401wt.eu-S940311AbXHMWQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940311AbXHMWQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbXHMWQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:16:16 -0400
Received: from smtp115.sbc.mail.re3.yahoo.com ([66.196.96.88]:46318 "HELO
	smtp115.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752040AbXHMWQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:16:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x3+jc6nOvNBEYvUT8b51KMqG3dZEX342j665DGbvsxl74CeFMwoarRN9Mmunwg2i5PEGF9uISy8xZMUeHGJ+npyLuJDSoAIyc3RqbYZJlbFptkXmbpPz++kbg4f2BxyxpwFjwEhmlFgvkMwiIfdxUYml5mxgfazVt4qu7ZNVsWI=  ;
X-YMail-OSG: .3BdoyMVM1mS3_CSb23V7F6740aUAod_KjybdCmf52NESZTctEVT9knpXF6UW1p2JPDoiLatTA--
From: David Brownell <david-b@pacbell.net>
To: Stuart_Hayes@dell.com
Subject: Re: EHCI Regression in 2.6.23-rc2
Date: Mon, 13 Aug 2007 15:16:18 -0700
User-Agent: KMail/1.9.6
Cc: webmaster@dragonslave.de, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, jikos@jikos.cz
References: <200708101045.57166.dex@dragonslave.de> <200708101508.21389.webmaster@dragonslave.de> <DFEF91B22ED07447AB6AA4B237F913F9B18E4E@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18E4E@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708131516.18675.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007, Stuart_Hayes@dell.com wrote:
> With the VIA controller I have,

Which kind is that?  The VT6202 is buggy as all get-out, and
they sold a *LOT* of those discrete chips for use in add-on PCI
cards.  We generally warn people away from those.  A more current
version is the VT6212, which was much more usable.  (If it says
EHCI 0.95, it's a VT6202... their EHCI 1.0 chips were much better.)


> after I set the "inactivate" bit, I 
> eventually see the controller set bit 1 in the overlay token
> (SplitXstate), indicating that it's running the transaction, and, a
> couple microframes later, it clears that bit again.  The transaction is
> not inactivated.

> ...

> Perhaps for now the best thing would just be to bypass the EHCI CPU
> frequency notifier code (i.e., my patch) for VIA EHCI controllers, since
> they are broken.  Would a hard-coded blacklist (just an "if
> (manufacturer==VIA)..." type thing) be OK?

Yes ... although if you don't need to blacklist their EHCI 1.0 chips
don't do it.  (Any VIA EHCI integrated into a southbridge is going
to follow spec rev 1.0 pretty well, modulo idiosyncratic timings.)


> I've also acquired a card with an NEC EHCI controller on it, which I'm
> going to look at while I'm into it...

Another case where there are a lot of add-on "EHCI 0.95" cards; but
in this case the quirks were less significant.

- Dave
