Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZCWIFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZCWIFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZCWIFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:05:07 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63129 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZCWIFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=rEthvAqlCXZyAPIKCXwGDrFIj9pkGwc9NWjMvItWr2LuZYh6h2G6nvPXINbsTeBYst
         lcKVf0hnoZq3FDX/Nwj4mog8GB5ID5ndhniY59Whw7C9cgGZLRyhYzzsHF/by1AtSnj/
         bq/zbGwZ5ToCfMr4zDkLcDcSnMTKSg7eEUjqs=
Date: Mon, 23 Mar 2009 08:04:55 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, marcin.slusarz@gmail.com, netdev@vger.kernel.org,
       k-keiichi@bx.jp.nec.com, stable@kernel.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
Message-ID: <20090323080455.GA4976@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322.212107.55546529.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-03-2009 05:21, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Sun, 22 Mar 2009 20:20:58 -0500
> 
>> On Sun, 2009-03-22 at 12:02 +0100, Marcin Slusarz wrote:
>>> When ndo_open (eg skge_up) function printks something, netconsole decides
>>> it can use this device because it checks state only (netif_running) which is
>>> set before ndo_open. Check device flags too.
>> That's fairly unfortunate semantics for netif_running. But if Dave
>> agrees that it's reasonable for that to be set to true at this point in
>> time, then I guess we'll go with it.
> 
> These kind of printk's simply are not allowed, we've removed such
> printk's from other driver ->open() methods to fix this problem and
> that's what should be done here.

What is the rationale of this decision? printk is a basic tool,
especially designed to work in as many places as possible, and
netconsole is rather something secondary (sorry Matt)?!

Jarek P.
