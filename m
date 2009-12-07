Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbZLGSMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbZLGSMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964921AbZLGSMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:12:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:42060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964911AbZLGSML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:12:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="473582046"
Subject: Re: linux-next: net/kbuild trees build failure
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091207160903.GB18939@tuxdriver.com>
References: <20091207200317.57820f0a.sfr@canb.auug.org.au>
	 <20091207114158.GA2428@merkur.ravnborg.org> <4B1CF39A.5050806@suse.cz>
	 <20091207160903.GB18939@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 10:12:17 -0800
Message-Id: <1260209537.4653.778.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Mon, 2009-12-07 at 08:09 -0800, John W. Linville wrote:
> On Mon, Dec 07, 2009 at 01:22:50PM +0100, Michal Marek wrote:
> > On 7.12.2009 12:41, Sam Ravnborg wrote:
> > > On Mon, Dec 07, 2009 at 08:03:17PM +1100, Stephen Rothwell wrote:
> > >> Hi Dave,
> > >>
> > >> Today's linux-next build (powerpc allyesconfig) failed like this:
> > >>
> > >> In file included from drivers/net/wireless/iwlwifi/iwl3945-base.c:57:
> > >> drivers/net/wireless/iwlwifi/iwl-core.h:66:30: error: linux/utsrelease.h: No such file or directory
> > >>
> > >> Caused by commit 250cce26d5d03337aec4ff8405121f026adb4a89 ("iwlwifi:
> > >> driver version track kernel version") from the net tree interacting with
> > >> commit 8e5c76aace9705b6983cfbf5eb2f2e869dab6738 ("kbuild: move
> > >> utsrelease.h to include/generated") from the kbuild tree.
> > >>
> > >> I applied this patch for today (and will carry it as necessary):
> > > 
> > > The right fix would be to use 'utsname()->sysname' (I think sysname
> > > is the right member).
> > 
> > ->release would be the right one. One could also question why iwlwifi
> > needs to repeat the kernel version it was built / is running against,
> > but I that's not the point here :). Dave, John, can we agree that
> > whichever tree gets merged first, the other tree applies the one-liner?
> 
> Hmmm...well, the suggested fixes are fine for the printk (i.e. runtime)
> usage.  But (other than Stephen's) they don't seem to help with the
> MODULE_VERSION (i.e. compile time) usage.  Is there an approved
> solution for that?

Right - could we please use the solution that works at compile time? I
used UTS_RELEASE after learning about its use in init/version.c, would
that not make it an approved solution?

> For some reason the Intel drivers encode some of their build options
> into their MODULE_VERSION string.

This has been useful many times, especially to know if users compiled
with debug support so that we can immediately support users to
understand why the debug flags they are providing does not work.

>   Other than that, the vermagic
> field from modinfo would seem to suffice for replacing this version
> information.  Honestly, I'm not too fond of the "build options in
> the version string" stuff...perhaps we could just get rid of it all?

I would prefer not to since it has been useful on many occasions
already.

Reinette


