Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbZGTUpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbZGTUpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZGTUpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:45:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:57314 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZGTUpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:45:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,236,1246863600"; 
   d="scan'208";a="431794824"
Subject: Re: iwl3945: fix LED config option
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
In-Reply-To: <20090718102030.GA2040@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz>
	 <1246298908.17896.391.camel@rc-desk> <20090709093859.GA10001@elf.ucw.cz>
	 <1247153986.17896.1233.camel@rc-desk>  <20090718102030.GA2040@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 13:45:30 -0700
Message-Id: <1248122730.17896.2582.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Sat, 2009-07-18 at 03:20 -0700, Pavel Machek wrote:
> On Thu 2009-07-09 08:39:46, reinette chatre wrote:
> > On Thu, 2009-07-09 at 02:38 -0700, Pavel Machek wrote:
> > > > > 
> > > > > (Also wifi LED stopped working on x60, but that's older issue).
> > > > 
> > > > Is there a bug report for this?
> > > 
> > > Well... I thought that was known issue?
> > > 
> > > Anyway, wifi LED used to work on x60 before driver rewrite. Now it is
> > > broken. I thought it is known/missing functionality? ...but I'd like
> > > to get it back :-).
> > 
> > Sorry ... but I have to ask ... did you compile with
> > CONFIG_IWLWIFI_LEDS ? If you still have issues - please do submit a bug
> > report.
> 
> Aha, this explains it:
> 
>   Enable LED support in iwlagn and iwl3945 drivers (IWLWIFI_LEDS) [N/y] (NEW) ?
> 
> Sorry, no help available for this option yet.
> 
> ...maybe LEDS should be default Y?
> 									Pavel
> 
> ---
> 
> IWLWIFI_LEDS option should certainly have help comment, 

Currently is reads (as you also have below) "Enable LED support in
iwlagn and iwl3945 drivers". This seems clear to me. 

> and should
> default to y. 

This makes sense.

> Actually I wonder if it should be user configurable at
> all, is there good reason?

Some users find the LED annoying and like to have a way to disable it.

> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
> index e092af0..95d9aa5 100644
> --- a/drivers/net/wireless/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/iwlwifi/Kconfig
> @@ -9,6 +9,10 @@ config IWLWIFI
>  config IWLWIFI_LEDS
>  	bool "Enable LED support in iwlagn and iwl3945 drivers"
>  	depends on IWLWIFI
> +	default y

This is reasonable.

> +	---help---
> +	  Useful to get Wifi LED working at least on Thinkpad notebooks.

I do not think this says more than what we already have. I actually
think noting something about a particular platform will increase
confusion (as in "so where is the option if I have an acer laptop?")
because this option is needed to get LED support on all platforms. I do
think what is currently written is sufficient, but if you insist on
having some text there I think it should be simpler. Something like
"Select this if you want LED support."


Reinette


