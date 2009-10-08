Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbZJHAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbZJHAQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 20:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZJHAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 20:16:00 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:17248 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZJHAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 20:15:58 -0400
Date: Wed, 7 Oct 2009 17:12:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
Message-Id: <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
In-Reply-To: <1254957256.3713.10.camel@johannes.local>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	<1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	<4ACD0E5A.7060106@oracle.com>
	<1254954842.3713.7.camel@johannes.local>
	<4ACD1C3D.3030506@oracle.com>
	<1254957256.3713.10.camel@johannes.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4ACD2EEB.008F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Oct 2009 01:14:16 +0200 Johannes Berg wrote:

> On Wed, 2009-10-07 at 15:54 -0700, Randy Dunlap wrote:
> 
> > > But they also select WIRELESS_EXT, which should cause WEXT_CORE to be
> > > turned on. Is it possible that is failing?
> > 
> > # CONFIG_WIRELESS is not set
> > CONFIG_WIRELESS_EXT=y
> > CONFIG_WEXT_SPY=y
> > CONFIG_WEXT_PRIV=y
> > 
> > WEXT_CORE is not enabled.  I haven't found the culprit, but I suspect "select".
> 
> Interesting.
> 
> > but what in WIRELESS_EXT would also cause WEXT_CORE to be enabled?
> 
> Well, the way WEXT_CORE is defined as def_bool y ought to, no?

Ah, I see what you mean.

Here's what's happening:

net/wireless/Kconfig says:

config WEXT_CORE
	def_bool y
	depends on CFG80211_WEXT || WIRELESS_EXT


and net/Kconfig says:

if WIRELESS

source "net/wireless/Kconfig"
source "net/mac80211/Kconfig"

endif # WIRELESS


so WEXT_CORE actually depends on NET && WIRELESS && (CFG80211_WEXT || WIRELESS_EXT)
(that's what xconfig shows me).
But WIRELESS is not enabled.  Pooh.

I was already toying with making CONFIG_WIRELESS a real/usable kconfig symbol.
That may have to be done unless someone else comes up with another solution.

---
~Randy
