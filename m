Return-Path: <linux-kernel-owner+w=401wt.eu-S1760443AbXKHCyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760443AbXKHCyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbXKHCxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:53:52 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:37415 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753081AbXKHCxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:53:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RPPJ6kZFCaKGJz6PXQCcd2NbxWaW9mVC9yHM8NuLqXcQdvHgzerRa6dTyUjVOd9SJTlzUHVA88K6eWYDOlNohQjzFthrHMB5oDgovMlH6z7HSJHrssCf3APLcuRyL73WyACY6wL/2cqbMpFFsOOQMWxK7wLz03qcPLYptfauibo=  ;
X-YMail-OSG: iUEwE4IVM1klPdGEfQ81dyuy3M8cNppB4R0WKv.halUIn8R_9yNdnlPjjHTCFImu7nxtESbuEw--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function `usbnet_set_settings':
Date: Wed, 7 Nov 2007 18:53:48 -0800
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
References: <200711012024.57412.toralf.foerster@gmx.de> <200711071434.52607.david-b@pacbell.net> <20071107225232.GB26163@stusta.de>
In-Reply-To: <20071107225232.GB26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071853.48460.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007, Adrian Bunk wrote:
> On Wed, Nov 07, 2007 at 02:34:52PM -0800, David Brownell wrote:
> > > > But on the other hand, it seems that only the ASIX code will work
> > > > right; the DM9601 and MCS7830 Kconfig is different/wrong.
> > > 
> > > I'm not seeing the problem.
> > > 
> > > Which configuration will be handled wrongly?
> > 
> > Notice how only the ASIX kconfig depended on NET_ETHERNET...
> > since MII depends on NET_ETHERNET, and (last I knew) the
> > reverse dependencies didn't capture the complete dependency
> > tree, selecting only MII would leave out some stuff.
> 
> Except for one s390 net driver (I'll check why it's doing this) the 
> NET_ETHERNET option does not influence what code is being generated - 
> it's just a Kconfig-internal option allowing to disable a huge bunch
> of drivers at once.

Drivers like ... AX88xxx, DM9601, and MCS7830!!  Except as
it turns out, only the first one behaves as intended.

You can tell it's a problem by the way it's inconsistent,
regardless of the details of the problem.  :)

- Dave
