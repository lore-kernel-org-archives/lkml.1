Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXBYTDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXBYTDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 14:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965107AbXBYTDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 14:03:40 -0500
Received: from stinky.trash.net ([213.144.137.162]:48013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965105AbXBYTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 14:03:39 -0500
Message-ID: <45E1DD88.6080206@trash.net>
Date: Sun, 25 Feb 2007 20:03:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Martin Josefsson <gandalf@wlug.westbo.se>
CC: Chuck Ebbert <cebbert@redhat.com>, netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>	 <45E04468.7020001@trash.net> <45E06546.504@redhat.com>	 <45E1C7E0.9070102@trash.net> <1172428694.4485.31.camel@localhost.localdomain>
In-Reply-To: <1172428694.4485.31.camel@localhost.localdomain>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Josefsson wrote:
> What about this case:
> 
> 1. Conntrack entry is created and placed on the unconfirmed list
> 2. The event cache bumps the refcount of the conntrack entry
> 3. module removal of ip_conntrack unregisters all hooks
> 4. packet is dropped by an iptables rule
> 5. packet is freed but we still have a refcount on the conntrack entry
> 
> Now there's no way to get that refcount to decrease as that only happens
> when the event cache receives another packet or the current packet makes
> it through the stack as you wrote above. And neither of this will happen
> since we unregistered the hooks providing the packets and dropped the
> packet.

The event cache is flushed on conntrack module unload after the hooks
have been unregistered, which should release all references.
