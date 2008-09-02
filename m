Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYIBNEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYIBNEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYIBNEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:04:41 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:51859 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbYIBNEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xmW1wn2GgrsjEdDh43j1+rtQ9uON9GIkGHAUKFpzbkZsTVDBWbmrqB1fqxJG+hsWiN
         3seR9qFNG42vPC74ff/kL0dxo+stYZSsl6kWNPPqATICJczZx6D2Z2bUwo7GykTn9ld8
         dJEFp6XFDwTs+AIhHgrdCwGkAlVbXl7ErQ9ck=
Date: Tue, 2 Sep 2008 16:04:31 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org,
       Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902130429.GB19172@google.com>
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com> <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 08:10:09AM +0200, Johannes Berg wrote:
> Zhu Yi wrote:
> > On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
> >> [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
> >> [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
> >> (capab=0x411 status=0 aid=1)
> >> [16482.918564] eth1: associated
> >> [16492.920224] eth1: disassociating by local choice (reason=3)
> >> [16492.920986] eth1: disassociating by local choice (reason=3)
> >
> > It is exactly 10 seconds the local STA sends the deauth_leaving frame
> > before associated everytime. I wonder if it is the timeout for some
> > wireless config tools. NM?
> 
> "by local choice" means wext requested this, not a kernel bug.
> 
> johannes

Sure, it's wpa_supplicant in ubuntu gutsy doing it.

$wpa_supplicant -version
 wpa_supplicant v0.5.8
 Copyright (c) 2003-2007, Jouni Malinen <j@w1.fi> and contributors

But it happens to work fine without 8ab65b03b7893da4a49009e7e356e36e27b0c407.

So yes, this could be some assumption that wpa_supplicant makes and that
fails now. I guess I will try the latest version from source and report.
