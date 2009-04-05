Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZDEJi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZDEJi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 05:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZDEJiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 05:38:16 -0400
Received: from bu3sch.de ([62.75.166.246]:48357 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZDEJiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 05:38:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: ath9k becon loss messages
Date: Sun, 5 Apr 2009 11:36:15 +0200
User-Agent: KMail/1.9.9
Cc: Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       linville@tuxdriver.com
References: <1238923439.4120.9.camel@localhost.localdomain> <200904051129.38904.mb@bu3sch.de>
In-Reply-To: <200904051129.38904.mb@bu3sch.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904051136.15285.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 11:29:38 Michael Buesch wrote:
> On Sunday 05 April 2009 11:23:59 Jaswinder Singh Rajput wrote:
> > With latest linus tree I am getting, .config file attached:
> > 
> > [   22.895051] r8169: eth0: link down
> > [   22.897564] ADDRCONF(NETDEV_UP): eth0: link is not ready
> > [   22.928047] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > [   22.982292] libvirtd used greatest stack depth: 4200 bytes left
> > [   63.709879] wlan0: authenticate with AP 00:11:95:9e:df:f6
> > [   63.712096] wlan0: authenticated
> > [   63.712127] wlan0: associate with AP 00:11:95:9e:df:f6
> > [   63.726831] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471 status=0 aid=1)
> > [   63.726855] wlan0: associated
> > [   63.730093] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > [   74.296087] wlan0: no IPv6 routers present
> > [   79.349044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  119.358200] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  179.354292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  259.366044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  359.348292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  361.953459] packagekitd used greatest stack depth: 4160 bytes left
> > [  478.824258] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  598.813343] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  718.817292] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  838.824567] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [  958.815402] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1078.848434] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1198.822913] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1318.824931] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1438.814157] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1558.827336] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1678.823011] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1798.830589] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 1918.828044] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2038.827224] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2116.517152] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2158.840243] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> > [ 2278.827427] wlan0: beacon loss from AP 00:11:95:9e:df:f6 - sending probe request
> 
> 
> I think this message should only show if CONFIG_MAC80211_VERBOSE_DEBUG is set.
> It's kind of expected that we lose a beacon once in a while, so we shouldn't print
> verbose messages to the kernel log (even if they are KERN_DEBUG).
> 
> And besides that, I think one can easily remotely trigger this message and flood the logs.
> So it should probably _also_ be ratelimited.
> 

Something like this:


Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-05 11:32:16.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-05 11:35:57.000000000 +0200
@@ -945,9 +945,13 @@ void ieee80211_beacon_loss_work(struct w
 			     u.mgd.beacon_loss_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "
-	       "- sending probe request\n", sdata->dev->name,
-	       sdata->u.mgd.bssid);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	if (net_ratelimit()) {
+		printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "
+		       "- sending probe request\n", sdata->dev->name,
+		       sdata->u.mgd.bssid);
+	}
+#endif
 
 	ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
 	ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
@@ -1007,9 +1011,13 @@ static void ieee80211_associated(struct 
 	      (local->hw.conf.flags & IEEE80211_CONF_PS)) &&
 	    time_after(jiffies,
 		       ifmgd->last_beacon + IEEE80211_MONITORING_INTERVAL)) {
-		printk(KERN_DEBUG "%s: beacon loss from AP %pM "
-		       "- sending probe request\n",
-		       sdata->dev->name, ifmgd->bssid);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: beacon loss from AP %pM "
+			       "- sending probe request\n",
+			       sdata->dev->name, ifmgd->bssid);
+		}
+#endif
 		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
 		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 					 ifmgd->ssid_len, NULL, 0);

-- 
Greetings, Michael.
