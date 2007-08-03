Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbXHCS3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbXHCS3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXHCS3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:29:12 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:40556 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752547AbXHCS3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:29:10 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: Eugene Surovegin <ebs@ebshome.net>
Cc: kernel-janitors@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/13] dev->priv to netdev_priv(dev), for drivers/net/ibm_emac
References: <200708031734.TAA00777@ifs.emn.fr>
	<20070803174754.GA1352@gate.ebshome.net>
Date: Fri, 03 Aug 2007 20:27:06 +0200
In-Reply-To: <20070803174754.GA1352@gate.ebshome.net> (Eugene Surovegin's
	message of "Fri, 3 Aug 2007 10:47:54 -0700")
Message-ID: <87ir7w324l.fsf_-_@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eugene Surovegin <ebs@ebshome.net> writes:

> On Fri, Aug 03, 2007 at 07:34:19PM +0200, Yoann Padioleau wrote:
>> 
>> Replacing accesses to dev->priv to netdev_priv(dev). The replacment
>> is safe when netdev_priv is used to access a private structure that is
>> right next to the net_device structure in memory. Cf
>> http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
>> This is the case when the net_device structure was allocated with
>> a call to alloc_netdev or one of its derivative.
>
> NAK.
>
> While that assumption is correct for the actual emac net device, it's 
> not for MAL poll one.

I forgot to add another condition in my semantic patch. 

I was looking only for xxx->priv = yyy; 
with this rule:

@ danger @
struct net_device *dev;
expression E;
@@
 dev->priv = E

whereas sometimes it's written xxx.priv = yyy; 
as in ibm_emac_mal ( mal->poll_dev.priv = mal; )

By adding the following rule in my semantic patch I correctly
_dont_ modify anything under drivers/net/ibm_emac

@ danger @
struct net_device dev;
expression E;
@@
 dev.priv = E


It's also the case for  drivers/net/e1000/e1000_main.c.


>
> You patch breaks a working driver.
>
> -- 
> Eugene

