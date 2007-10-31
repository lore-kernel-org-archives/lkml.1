Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbXJaTfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbXJaTfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 15:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXJaTey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 15:34:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183AbXJaTex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 15:34:53 -0400
Date: Wed, 31 Oct 2007 12:33:59 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Bin Guo <bguo@sw.starentnetworks.com>
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX device?
Message-ID: <20071031123359.3954befc@freepuppy.rosehill>
In-Reply-To: <18216.52455.698606.497464@zeus.sw.starentnetworks.com>
References: <18216.52455.698606.497464@zeus.sw.starentnetworks.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 14:43:51 -0400
Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> wrote:

> 
> Depending on the network driver, I'm seeing different behavior if
> a .1q packet is received to an PF_PACKET, SOCK_RAW, ETH_P_ALL socket.
> 
> 
> On devices what do not use NETIF_F_HW_VLAN_RX, the packet socket gets
> the complete packet with vlan tag included as the driver simply calls
> netif_receive_skb() or equivilant.  packet_rcv() then gets the whole
> thing vlan tag included and sends this through the socket.
> 
> vlan_skb_recv() also gets these all and will drop them because there
> are no vlans configured.
> 

The VLAN acceleration grabs and hides the tag. It is a design flaw
that should be fixed, feel free to post a patch.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
