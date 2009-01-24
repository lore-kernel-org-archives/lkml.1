Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZAXN0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZAXN0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 08:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbZAXN0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 08:26:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:50832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246AbZAXN0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 08:26:14 -0500
Subject: Re: why usr/include/linux/if_frad.h is required
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, sam@ravnborg.org, jaswinderlinux@gmail.com,
       khc@pm.waw.pl, arnd@arndb.de, mingo@elte.hu, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090121.153712.84781438.davem@davemloft.net>
References: <20090121053310.GA26395@uranus.ravnborg.org>
	 <20090120.221504.264090722.davem@davemloft.net>
	 <20090121173838.3390e5c9@s6510>
	 <20090121.153712.84781438.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jan 2009 18:55:33 +0530
Message-Id: <1232803533.17900.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 15:37 -0800, David Miller wrote:
> From: Stephen Hemminger <shemminger@vyatta.com>
> Date: Wed, 21 Jan 2009 17:38:38 +1100
> 
> > There are no references if_frad.h in the version of Sangoma (out of
> > tree) code that we use in Vyatta.
> 
> frad-0.20:src/dlcicfg.c
> 
> It includes linux/if_frad.h and also performs the DLCI_SET_CONF
> ioctl.
> 
> Enough evidence to show we need to keep this header in the
> export set.  Let's just kill the bogus CONFIG_* ifdef
> tests in there.

After killing CONFIG_DLCI and CONFIG_DLCI_MODULE, it is also killing the
kernel:

  CC      net/socket.o
In file included from net/socket.c:75:
include/linux/if_frad.h:170: error: ‘CONFIG_DLCI_MAX’ undeclared here (not in a function)
make[1]: *** [net/socket.o] Error 1
make: *** [net] Error 2

because these things still depends on CONFIG_DLCI:

struct frad_local
{
   struct net_device_stats stats;

   /* devices which this FRAD is slaved to */
   struct net_device     *master[CONFIG_DLCI_MAX];
   short             dlci[CONFIG_DLCI_MAX];

Are you still sure we do not need CONFIG_DLCI.

--
JSR

