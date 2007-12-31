Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbXLaRzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbXLaRzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXLaRzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:55:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:42684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbXLaRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gJFbaR+iVKnV2IrTkIP+rJMEVbHwEu+n7CuNkCEuxDeQ0BUfCEBMF6unumPzKzt4WVANC73OojxaX4xPIcMDqiVFVepjEZTOWImG5cOk1ghCnkBEu8GaNoLLUxKIDDw3MajDke9kZJ60u6DWixj4yi+i/BtuMvSBNxg8siTxmjY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip[6]_tables.c: remove some inlines
Date: Mon, 31 Dec 2007 17:55:02 +0000
User-Agent: KMail/1.9.1
Cc: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
References: <200712161247.53986.vda.linux@googlemail.com> <200712311643.41946.vda.linux@googlemail.com> <47792032.3020609@trash.net>
In-Reply-To: <47792032.3020609@trash.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311755.02578.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 17:00, Patrick McHardy wrote:
> Denys Vlasenko wrote:
> > ip[6]_tables.c seem to abuse inline.
> >
> > This patch removes inlines except those which are used
> > by packet matching code and thus are performance-critical.
> >   
> 
> Some people also consider the ruleset replacement path performance
> critical, but overall I agree with your patch. I'm travelling currently
> though so it will take a few days until I'll apply it.
> 
> Do you have some numbers that show the actual difference these
> changes make?

Before:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6402     500      16    6918    1b06 net/ipv4/netfilter/ip_tables.o
   7130     500      16    7646    1dde net/ipv6/netfilter/ip6_tables.o

After:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6307     500      16    6823    1aa7 net/ipv4/netfilter/ip_tables.o
   7010     500      16    7526    1d66 net/ipv6/netfilter/ip6_tables.o

--
vda
