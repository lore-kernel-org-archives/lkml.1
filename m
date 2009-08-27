Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbZH0WW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbZH0WW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 18:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZH0WWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 18:22:55 -0400
Received: from mail-yw0-f184.google.com ([209.85.211.184]:55327 "EHLO
	mail-yw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZH0WWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 18:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m71q0Bcv+P/qxa7OH4BtYy0W7sfLQO+8DpByOl8Xc/51EoTd1oUjTJu0n0IYH7Hvz9
         g8yBt2Dz3rVD/lG8trCSJZPkwa5kSgi0jYIigI39DeEbJgAFE2djT61OaUfAcytGVXuT
         vSUoPS/SRpCErEdOKfgQZs7TycHrcai7I+Cc4=
MIME-Version: 1.0
In-Reply-To: <9e8b01b1556687e0b78ca63dfb5ca8dc.squirrel@ssl.serverraum.org>
References: <9e8b01b1556687e0b78ca63dfb5ca8dc.squirrel@ssl.serverraum.org>
Date: Thu, 27 Aug 2009 15:22:55 -0700
Message-ID: <4807377b0908271522r43d7c25lcfbecbe0e6f0a467@mail.gmail.com>
Subject: Re: dropped packets with bonding and 8021q
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Michael Walle <michael@walle.cc>, NetDEV list <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to the networking mailing list

On Wed, Aug 19, 2009 at 3:29 AM, Michael Walle<michael@walle.cc> wrote:
>
> Hi,
>
> i have some strange bonding and vlan configuration. The bonding interface
> is in active-standby mode and i want to send and receive raw ethernet
> frames on _both_ enslaved interfaces. Additionally the frames are tagged
> with a vlan id. So one config could be:
>
> # modprobe bonding mode=1
> # modprobe 8021q
> # ifenslave bond0 eth1
> # ifenslave bond0 eth2
> # vconfig add eth1 10
> # vconfig add eth2 20
> # vconfig add bond0 1000
>
> # [activate bonding active slave etc..]
>
> I use raw/dgram sockets (AF_PACKET) with eth1.10 and eth2.20 (or dump the
> frames with tcpdump).
>
> As long as i don't use the bonding module everything works as expected.
> But if the physical interfaces are enslaved, frames received on the
> standby device will be dropped.
>
> The network driver is e1000. So the hardware acceleration for tagged VLAN
> frames gets used and the frame gets through __vlan_hwaccel_rx() in the
> receiving path. And there it seems to get dropped by
> skb_bond_should_drop().
>
> On the "normal" receive path there was a patch by Joe Eykholt that allows
> to receive frames on the physical interface even if it is enslaved and not
> active (git commit 0d7a3681232f545).
>
> Shouldn't __vlan_hwaccel_rx() (in net/8021q/vlan_core.c) be patched in the
> same way to allow reception on inactive enslaved interfaces?
>
> Thanks,
>  Michael
>
> PS. could you please cc me, as i'm not subscribed to the ml.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
