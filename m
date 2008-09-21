Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYIUUiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYIUUiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYIUUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:35:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:52847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYIUUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H+hd1N8VEC9MGBWZlnWC1MhZBoecVKuRh1GvlLiJlr9wcoZy/JMz92s6dKoc5CcYTm
         tKD0AxTdx3on3gJT6MH/Vt3KFhzO9vI9egkhh/57hVtV8YWOSl1ubxzZLovCmakoMfZZ
         cRmwj9BRunzXaDGKWfTOD0329mQHj0oSXD48E=
Date: Mon, 22 Sep 2008 00:35:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Arjan van de Ven <arjan@infradead.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw2100-devel@lists.sourceforge.net,
       linux-wireless@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, jgarzik@pobox.com, linville@tuxdriver.com,
       davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware
	restart.
Message-ID: <20080921203503.GL7736@localhost>
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921110422.1d010b96@infradead.org> <20080921182835.GA11473@2ka.mipt.ru> <20080921113513.16677c4e@infradead.org> <20080921190050.GA20484@2ka.mipt.ru> <1222024444.3023.53.camel@johannes.berg> <20080921193809.GA8735@2ka.mipt.ru> <20080921200518.GK7736@localhost> <20080921202656.GC25052@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921202656.GC25052@2ka.mipt.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Evgeniy Polyakov - Mon, Sep 22, 2008 at 12:26:56AM +0400]
| On Mon, Sep 22, 2008 at 12:05:18AM +0400, Cyrill Gorcunov (gorcunov@gmail.com) wrote:
| > Since it's that serious maybe we should change
| > 
| > 		IPW_DEBUG_INFO("%s: Fatal error value: 0x%08X\n",
| > 			       priv->net_dev->name, priv->fatal_error);
| > 
| > to printk(KERN_WARN)? And here is why - as I see now we can't say what
| > exactly is wrong - Evgeniy said he has a suspicious about firmware so
| > this WARNS will be collected by Arjan thru kerneloops and we could not
| > ask users to change debug level and repost problem - oops will have it
| > by default - and if it really firmware problem - firmware engineers could
| > find this _additional_ info usefull and resolve it (probably).
| 
| The only reason for this change is to make a mark at the kerneloops.
| I.e. users know, there is a bug. Developers know, there is a bug.
| Everyone knows that there is a bug, but until it is at the special place
| we look to each other just like there is no bug.
| 
| Here are dumps for example:
| http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=245
| 
| Bug existed even with 1.2 firmware and .11 kernel.
| Intel, that's a great marketing slogan: stability everywhere!
| 
| -- 
| 	Evgeniy Polyakov
| 

>From dump:
> Sep 25 11:31:39 suino wlan0: TX timed out.  Scheduling firmware restart.

yes Evgeniy - all could know that but this register info could help
firmware engineers to distinguish problems (without additional efforts
like ask users to pass debug argument - kerneloops will have it
by default) if there not only one exist. I mean I don't think anyone
would reject additional info about problem ever :)

		- Cyrill -
