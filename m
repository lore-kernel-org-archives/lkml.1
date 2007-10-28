Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXJ1Uqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXJ1Uqm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 16:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXJ1Uqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 16:46:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXJ1Uqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 16:46:30 -0400
Date: Sun, 28 Oct 2007 21:46:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Pavel Machek <pavel@ucw.cz>, Casey Schaufler <casey@schaufler-ca.com>,
       Chris Wright <chrisw@sous-sol.org>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework
In-Reply-To: <4724E63F.2030600@imap.cc>
Message-ID: <Pine.LNX.4.64.0710282125040.17164@fbirervta.pbzchgretzou.qr>
References: <20071025002356.GB3660@sequoia.sous-sol.org>
 <183239.5113.qm@web36604.mail.mud.yahoo.com> <20071027182229.GC4159@ucw.cz>
 <4724E63F.2030600@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 28 2007 20:42, Tilman Schmidt wrote:
>Am 27.10.2007 20:22 schrieb Pavel Machek:
>> Hi!
>> 
>>> but require unreasonable interface changes. As people who care
>>> about security (y'all who are only from the LKML are excused) it
>>> is our obligation to look beyond the preconceived notions of what
>>> is and isn't secure. Security is subjective. It's how you feel
>>> about it.
>> 
>> <sarcasm>Hmm. So lets add automagic security module. It magically fixes
>> security holes, and you can feel good about it.</sarcasm>
>
>Send patch.

Perfect security from threats that normally deliver via internet!
(And it is even one of these that benefit from being modular!)

#include <linux/kmod.h>
#include <linux/module.h>
#include <linux/netdevice.h>
#include <net/net_namespace.h>

static void cl(const char *name, const char *state)
{
	const char *args[] = {"ip", "link", "set", name, state, NULL};
	call_usermodehelper("/sbin/ip", (char **)args, NULL, UMH_NO_WAIT);
}  

int __init automagic_security_init(void)
{
	const struct net_device *dev;

	for_each_netdev(&init_net, dev)
		cl(dev->name, "down");

	return 0;
}

void __exit automagic_security_exit(void)
{
	const struct net_device *dev;   
 
	for_each_netdev(&init_net, dev)
		cl(dev->name, "up");

        return;
}

module_init(automagic_security_init);
module_exit(automagic_security_exit);
