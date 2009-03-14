Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbZCNW0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbZCNW0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZCNW0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:26:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZCNW0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:26:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: [Bug #12805] QinQ vlan trunking regression
Date: Sat, 14 Mar 2009 23:26:10 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bart@jukie.net, netdev@vger.kernel.org
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.RgD.w4BvJB@chimera> <20090314.150420.149174658.davem@davemloft.net>
In-Reply-To: <20090314.150420.149174658.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142326.11185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 March 2009, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Sat, 14 Mar 2009 20:05:33 +0100 (CET)
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12805
> > Subject		: QinQ vlan trunking regression
> > Submitter	: Bart Trojanowski <bart@jukie.net>
> > Date		: 2009-02-28 18:05 (15 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123584439115868&w=4
> 
> Fixed by:
> 
> commit 9d40bbda599def1e1d155d7f7dca14fe8744bd2b
> Author: David S. Miller <davem@davemloft.net>
> Date:   Wed Mar 4 23:46:25 2009 -0800
> 
>     vlan: Fix vlan-in-vlan crashes.
>     
>     As analyzed by Patrick McHardy, vlan needs to reset it's
>     netdev_ops pointer in it's ->init() function but this
>     leaves the compat method pointers stale.
>     
>     Add a netdev_resync_ops() and call it from the vlan code.
>     
>     Any other driver which changes ->netdev_ops after register_netdevice()
>     will need to call this new function after doing so too.
>     
>     With help from Patrick McHardy.
>     
>     Tested-by: Patrick McHardy <kaber@trash.net>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks, closed.

Rafael
