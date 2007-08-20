Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXHTKeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXHTKeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 06:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXHTKeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 06:34:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbXHTKeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 06:34:22 -0400
Date: Mon, 20 Aug 2007 12:34:17 +0200
From: Markus Dahms <mad@automagically.de>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: sparclinux <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Odp: possible endless loop in PROM initialization
Message-ID: <20070820103417.GA4911@vimes.madsworld.lan>
References: <20070820075949.GA5927@vimes.madsworld.lan> <46c955d43d407@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46c955d43d407@wp.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Provags-ID: V01U2FsdGVkX1+9+Gh671EIDuiqs/1U4PsXTstVqxWLtSG8kKt
 ZVHOm3uJ2WCF7u+9Ta6ZeYl8nGpTyoA3nUbTCGgcZXLSVkunIu
 KOyT7VJDMaYaagPk1zywA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Helt wrote,
> Could you give name of the function which contains this endless loop?
> When I looked into the tree.c file for the first time I thought
> it had a bug
> in handling the prom_nextprop, but later I concluded that this is ok.
> Maybe there is a bug there after all.

if I understood it correctly the following functions are called in this
order:

* prom_init()                    # arch/sparc/kernel/head.S
[...]
* create_node()                  # arch/sparc/kernel/prom.c
* build_prop_list()              # arch/sparc/kernel/prom.c
* build_one_prop()               # arch/sparc/kernel/prom.c
* prom_nextprop()                # arch/sparc/prom/tree.c
* __prom_nextprop()              # arch/sparc/prom/tree.c
* prom_nodeops->no_nextprop()    # PROM

And this loops while getting the attributes/properties of the /aliases
node.

Greetings,

	Markus
