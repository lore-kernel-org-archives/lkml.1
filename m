Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbZBLXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbZBLXWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZBLXWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:22:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44148
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbZBLXWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:22:11 -0500
Date: Thu, 12 Feb 2009 15:22:05 -0800 (PST)
Message-Id: <20090212.152205.81876086.davem@davemloft.net>
To: gregkh@suse.de
Cc: greg@kroah.com, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] staging/sxg: fix napi interface build
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090212230846.GA25058@suse.de>
References: <20090212195133.GB16214@kroah.com>
	<20090212.145620.268233419.davem@davemloft.net>
	<20090212230846.GA25058@suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 12 Feb 2009 15:08:46 -0800

> On Thu, Feb 12, 2009 at 02:56:20PM -0800, David Miller wrote:
> > From: Greg KH <greg@kroah.com>
> > Date: Thu, 12 Feb 2009 11:51:33 -0800
> > 
> > > On Wed, Feb 11, 2009 at 01:22:56PM -0800, Randy Dunlap wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > > 
> > > > Fix staging/sxg napi interface calls:
> > > > 
> > > > drivers/staging/sxg/sxg.c:1271: error: implicit declaration of function 'netif_rx_schedule_prep'
> > > > linux-next-20090209/drivers/staging/sxg/sxg.c:1272: error: implicit declaration of function '__netif_rx_schedule'
> > > > drivers/staging/sxg/sxg.c:1325: error: implicit declaration of function 'netif_rx_complete'
> > > 
> > > As I count over 80 instances of netif_rx_complete in Linus's tree right
> > > now, I'm guesing this is due to a change from the netdev tree.  Which is
> > > fine, but I'll wait until that gets merged with Linus to apply this
> > > patch.
> > 
> > Well it means that it won't build in -next until the next merge
> > window.
> 
> I can live with that :)
> 
> Or is the new api already there and it's safe to make this change now?

If you make the change, your driver will build in Linus's
tree.  Just sed 's/netif_rx_/napi_/' for the lines the
above warning triggers on.
