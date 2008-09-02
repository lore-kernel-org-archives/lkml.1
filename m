Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbYIBNaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbYIBNaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYIBNaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:30:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYIBNaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:30:11 -0400
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
From: Dan Williams <dcbw@redhat.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Zhu Yi <yi.zhu@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20080902130429.GB19172@google.com>
References: <20080901160658.GA11063@google.com>
	 <1220319536.28282.128.camel@debian.sh.intel.com>
	 <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net>
	 <20080902130429.GB19172@google.com>
Content-Type: text/plain
Date: Tue, 02 Sep 2008 09:30:01 -0400
Message-Id: <1220362201.3176.4.camel@borkbork.foobar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 16:04 +0300, Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2008 at 08:10:09AM +0200, Johannes Berg wrote:
> > Zhu Yi wrote:
> > > On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
> > >> [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
> > >> [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
> > >> (capab=0x411 status=0 aid=1)
> > >> [16482.918564] eth1: associated
> > >> [16492.920224] eth1: disassociating by local choice (reason=3)
> > >> [16492.920986] eth1: disassociating by local choice (reason=3)
> > >
> > > It is exactly 10 seconds the local STA sends the deauth_leaving frame
> > > before associated everytime. I wonder if it is the timeout for some
> > > wireless config tools. NM?
> > 
> > "by local choice" means wext requested this, not a kernel bug.
> > 
> > johannes
> 
> Sure, it's wpa_supplicant in ubuntu gutsy doing it.
> 
> $wpa_supplicant -version
>  wpa_supplicant v0.5.8
>  Copyright (c) 2003-2007, Jouni Malinen <j@w1.fi> and contributors
> 
> But it happens to work fine without 8ab65b03b7893da4a49009e7e356e36e27b0c407.

That's really odd; that patch (the don't-send-empty-extended-rates-IE
patch) shouldn't have anything to do with this behavior, if it did you
wouldn't get associated to the AP in the first place I think.  You're
100% sure that this patch is causing the problem?  Can you post the
output of running wpa_supplicant with the "-dddt" flags and also post
the 'iwlist scan' output for your AP?

Dan

