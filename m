Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYH1Ibt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYH1Ibt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYH1Ibi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:31:38 -0400
Received: from bu3sch.de ([62.75.166.246]:60930 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYH1Ibg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:31:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Thu, 28 Aug 2008 10:31:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080827013009.GA15781@tuxdriver.com> <200808272225.10557.mb@bu3sch.de> <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
In-Reply-To: <1ba2fa240808271611v382631ecn2a24e2816562d434@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281031.06529.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Tomas Winkler wrote:
> On Wed, Aug 27, 2008 at 11:25 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Wednesday 27 August 2008, Tomas Winkler wrote:
> >> > John W. Linville (1):
> >> >      mac80211: quiet chatty IBSS merge message
> >>
> >> This patch is correct yet it suppresses an important warning, meaning
> >> that you have constant IBSS reconnection, remove all connected station
> >> and adding them again, This greatly degraded performance. This is
> >> caused by inability to adjust to TSF of the IBSS leader
> >>
> >> <snipt>
> >> static int ieee80211_sta_join_ibss(struct net_device *dev,
> >>                                  struct ieee80211_if_sta *ifsta,
> >>                                  struct ieee80211_sta_bss *bss)
> >> .....
> >> /* Remove possible STA entries from other IBSS networks. */
> >>       sta_info_flush_delayed(sdata);
> >> </snip>
> >
> > I fail to see how the TSF could be related to an ever reconnecting
> > station. Can you elaborate on what happens?
> >
> > I was under the impression that the firmware would handle TSF stuff.
> > Also the "IBSS leader" is a new thing to me. I remember from the specs
> > that the device should accept the TSF from _any_ beacon. Not just a
> > "leader". Am I mislead? :)
> 
> What is happening that IBSS station should adopt TSF of  the oldest
> station i.e. with highest
> TSF. This is also leader of the IBSS (this is not spec definition just
> local jargon)  Adaptation
> mean we adjust to the same clock
> 
> if (beacon_timestamp > rx_timestamp)
>     merge

Well, I was pretty sure the firmware did this for us.
I can recheck that later.

In any case, I will accept patches that are _well_ _tested_ to workaround this
issue. I don't have the time work work on IBSS by myself. My pile already is
big enough. :)
