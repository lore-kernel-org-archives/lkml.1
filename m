Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYIFFhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYIFFhz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYIFFhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:37:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23035 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYIFFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:37:45 -0400
Date: Fri, 5 Sep 2008 22:36:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, "jgarzik" <jgarzik@pobox.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       <e1000-devel@lists.sourceforge.net>,
       "Morton" <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       <Andrew@sc8-sf-spam2-b.sourceforge.net>
Subject: Re: [E1000-devel] linux-next: Tree for September 4 (PATCH: IXGBE)
Message-Id: <20080905223634.7a05a2f5.randy.dunlap@oracle.com>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5206120576@orsmsx418.amr.corp.intel.com>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au>
	<20080904204137.9b31f644.randy.dunlap@oracle.com>
	<36D9DB17C6DE9E40B059440DB8D95F5206120576@orsmsx418.amr.corp.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008 16:47:55 -0700 Brandeburg, Jesse wrote:

> Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > ixgbe needs to be restricted to the same build config (m/y)
> > as DCA since it calls the dca_*() functions.
> > 
> > ixgbe_main.c:(.text+0xd9c09): undefined reference to `dca3_get_tag'
> > ixgbe_main.c:(.text+0xd9cc9): undefined reference to `dca3_get_tag'
> > ixgbe_main.c:(.text+0xda5c1): undefined reference to
> > `dca_add_requester' ixgbe_main.c:(.text+0xda5d6): undefined reference
> > to `dca_remove_requester' text+0xdc162): undefined reference to
> > `dca_add_requester' 
> > text+0xdc1d3): undefined reference to `dca_remove_requester'
> > ixgbe_main.c:(.init.text+0xa74b): undefined reference to
> > `dca_register_notify' ixgbe_main.c:(.devinit.text+0xa4ca): undefined
> > reference to `dca_add_requester' ixgbe_main.c:(.exit.text+0xd21):
> > undefined reference to `dca_unregister_notify'
> > ixgbe_main.c:(.devexit.text+0x72d): undefined reference to
> > `dca_remove_requester' make[1]: *** [.tmp_vmlinux1] Error 1 
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ...
> > +	depends on PCI && INET && DCA
> 
> Looks like you set IXGBE=y and CONFIG_DCA=m.  This depends DCA option is
> not so great because if INTEL_IOATDMA is disabled (and therefore DCA is
> disabled) then ixgbe won't show up as an option.
> 
> How about this instead, use a select INTEL_IOATDMA:
> 
> inline is whitespace busted, sorry. attached is the patch.

OK, that works.  Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
