Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXIZWeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXIZWeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbXIZWd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:33:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbXIZWd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:33:58 -0400
Date: Wed, 26 Sep 2007 15:33:30 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Oleg Verych <olecom@flower.upol.cz>, Jan Beulich <jbeulich@novell.com>,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: why network devices don't do reference counting? (Re: [PATCH]
 Module use count must be updated as bridges are created/destroyed)
Message-ID: <20070926153330.77aade4d@freepuppy.rosehill>
In-Reply-To: <Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
References: <46FA2C17.76E4.0078.0@novell.com>
	<20070926083705.6bc65ea5@fujitsu-loaner>
	<E1Iae5t-0007Sk-Vu@flower>
	<20070926140608.6e6d3d0c@freepuppy.rosehill>
	<Pine.LNX.4.64.0709270017120.17414@fbirervta.pbzchgretzou.qr>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 00:18:55 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Sep 26 2007 14:06, Stephen Hemminger wrote:
> >> >
> >> > No, network devices don't do reference counting.
> >> 
> >> Could you explain why, please?
> >> 
> >> After `udevd` on boot loads lots of unused crap, i surrendered, and use
> >> $(rmmod `lsmod | just first column`). Networing bravely wipes away. OK,
> >> there are lots of configs: udev, hotplug, modprobe, that somebody might
> >> like to fix. But it came to the end with me. I just don't care. So,
> >> please answer :)
> >
> >For hotplug and other reasons, the network developers decided that being
> >able to remove a network module at any time was a good thing. It works.
> 
> Except that for ipv6.ko, it's all opposite. After modprobe,
> it already got a refcount like 8 and you're wondering how
> to get rid of that.

ipv6 is not a network driver, it is a protocol. You might be able to remove it if you zap
all the routes and applications, ...

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
