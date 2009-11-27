Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZK0NJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZK0NJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZK0NJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:09:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZK0NJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:09:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCH 1/3] netdevice: provide common routine for macvlan and vlan operstate management
Date: Fri, 27 Nov 2009 14:09:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: kaber@trash.net, netdev@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
References: <20091113195201.11184.25766.stgit@mimic.site> <20091113195513.11184.63631.stgit@mimic.site>
In-Reply-To: <20091113195513.11184.63631.stgit@mimic.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911271409.28810.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18WWSUnZLWr5awuuKb6AWqt0fBNzp6AsVTZ4TL
 ZOQoX+ri/I2NkP/GCUN70ynNad4LiJ1vB6S04KpfBRdRp5V+qW
 RPFwpb1zis//Msbssz9PA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Patrick Mullaney wrote:
> @@ -551,7 +532,7 @@ static int macvlan_newlink(struct net_device *dev,
>                 return err;
>  
>         list_add_tail(&vlan->list, &port->vlans);
> -       macvlan_transfer_operstate(dev);
> +       netif_stacked_transfer_operstate(dev, lowerdev);
>         return 0;
>  }
>  
> @@ -591,7 +572,8 @@ static int macvlan_device_event(struct notifier_block *unused,
>         switch (event) {
>         case NETDEV_CHANGE:
>                 list_for_each_entry(vlan, &port->vlans, list)
> -                       macvlan_transfer_operstate(vlan->dev);
> +                       netif_stacked_transfer_operstate(vlan->dev,
> +                                                        vlan->lowerdev);
>                 break;
>         case NETDEV_FEAT_CHANGE:
>                 list_for_each_entry(vlan, &port->vlans, list) {

These have the arguments reversed, lowerdev should come first.

	Arnd <><
