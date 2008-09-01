Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbYIAQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbYIAQH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYIAQHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:07:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:35190 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYIAQHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HdXt/voQ0dT89X2rXbp0SINZ7IaXnWUK7uXQX/Ckfw1WpwICWdju7KNE9wbSoxlFaX
         qmUe8N4Oj74TH48zUbfXvHne8RnMms1MUL6LygKOI9PSlePMRovDT3iiK147+crsS5eG
         SAQu+odTFSViVGfu/qDyl1dU64zIjv/BxKPgw=
Date: Mon, 1 Sep 2008 19:07:01 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       johannes@sipsolutions.net, Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080901160658.GA11063@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with 2.6.27-rc5, my T60p sometimes fails to associate
with an access point after suspend to ram/resume.

This does not seem to ever happen on 2.6.27-rc4.

When this happens, I observe the following messages in dmesg:
(AP mac masked out with XX):


[16433.458084] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[16433.502490] PM: Adding info for No Bus:iwl-phy4:radio
[16433.502666] Registered led device: iwl-phy4:radio
[16433.502764] PM: Adding info for No Bus:iwl-phy4:assoc
[16433.502822] Registered led device: iwl-phy4:assoc
[16433.502870] PM: Adding info for No Bus:iwl-phy4:RX
[16433.503006] Registered led device: iwl-phy4:RX
[16433.503055] PM: Adding info for No Bus:iwl-phy4:TX
[16433.503111] Registered led device: iwl-phy4:TX
[16433.505268] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16433.522344] ADDRCONF(NETDEV_UP): eth1: link is not ready
[16433.704125] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16433.705986] eth1: authenticated
[16433.705997] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16433.708406] eth1: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16433.708412] eth1: associated
[16433.709659] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[16443.712280] eth1: disassociating by local choice (reason=3)
[16443.712902] eth1: disassociating by local choice (reason=3)
[16444.692059] eth1: no IPv6 routers present
[16445.997384] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16445.999304] eth1: authenticated
[16445.999312] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16446.001784] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16446.001790] eth1: associated
[16446.008222] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16446.009539] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16446.012433] eth1: authenticated
[16446.012440] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16446.015149] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16446.015155] eth1: associated
[16456.017223] eth1: disassociating by local choice (reason=3)
[16456.019751] eth1: disassociating by local choice (reason=3)
[16458.298346] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16458.300319] eth1: authenticated
[16458.300339] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16458.305557] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16458.314765] eth1: authenticated
[16458.314781] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16458.318666] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16458.318673] eth1: associated
[16468.321210] eth1: disassociating by local choice (reason=3)
[16470.604081] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16470.606122] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16470.608330] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16470.608367] eth1: authenticated
[16470.608374] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16470.614629] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16470.614648] eth1: associated
[16480.617268] eth1: disassociating by local choice (reason=3)
[16480.619939] eth1: disassociating by local choice (reason=3)
[16482.896840] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16482.899593] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16482.899626] eth1: authenticated
[16482.899633] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16482.906006] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16482.906048] eth1: authenticated
[16482.906055] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16482.907625] eth1: authenticate with AP XX:XX:XX:XX:XX:XX
[16482.909446] eth1: authenticated
[16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
[16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX (capab=0x411 status=0 aid=1)
[16482.918564] eth1: associated
[16492.920224] eth1: disassociating by local choice (reason=3)
[16492.920986] eth1: disassociating by local choice (reason=3)


Reverting 8ab65b03b7893da4a49009e7e356e36e27b0c407 seems to make
the card associate properly after suspend, for me.

-- 
MST

