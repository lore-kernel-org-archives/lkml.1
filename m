Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbZHRFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbZHRFcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZHRFcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:32:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:1956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbZHRFcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:mime-version:content-type
         :content-disposition:user-agent:message-id;
        b=AYjVZ4trJlwOXfcCzzkX7hr/ql8o90oRkcrV+o5zk67w0fbPFgej16hj/6/sh4ZQbd
         qRPjX6lNpTa9jmuH/ilTsNbNi6w1IO3nsD1hKv5sXqNQ6RqIDn9T+K5yCkgdX9hKPGOc
         movWUZlBeYDOoLqZkYSqHdFflC1yQl0IrG6F4=
Date: Mon, 17 Aug 2009 22:32:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Dell-laptop is not working without wireless
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090818060340.E1C7A526EA5@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew,

Not sure if this has already been reported, but here it goes:

dell-laptop module does not work on my Latitude d630 unless driver for
my wireless card (which happens to be iwl3945) is already loaded.
Otherwise dcsbas_smi_request() returns all zeroes which causes
dell-laptop to not create any rfkill devices nor install backlight
device:

[  766.262842] dell-laptop: dell_setup_rfkill() - 0, 0, 0, 0
[  766.263087] dell-laptop: max intensity is 0
[  780.388460] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network
Connection driver for Linux, 1.2.26kds
[  780.388464] iwl3945: Copyright(c) 2003-2009 Intel Corporation
[  780.388584] iwl3945 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[  780.388605] iwl3945 0000:0c:00.0: setting latency timer to 64
[  780.446318] iwl3945 0000:0c:00.0: Tunable channels: 11 802.11bg, 13
802.11a channels
[  780.446322] iwl3945 0000:0c:00.0: Detected Intel Wireless WiFi Link
3945ABG
[  780.446474] iwl3945 0000:0c:00.0: irq 29 for MSI/MSI-X
[  780.451713] phy1: Selected rate control algorithm 'iwl-3945-rs'
[  785.216846] iwl3945 0000:0c:00.0: firmware: requesting
iwlwifi-3945-2.ucode
[  785.233257] iwl3945 0000:0c:00.0: loaded firmware version 15.32.2.9
[  785.303299] Registered led device: iwl-phy1::radio
[  785.303445] Registered led device: iwl-phy1::assoc
[  785.303522] Registered led device: iwl-phy1::RX
[  785.303597] Registered led device: iwl-phy1::TX
[  799.213373] dell-laptop: dell_setup_rfkill() - 0, 1031f, 100, 1
[  799.213383] dell-laptop: setting up dell-wifi rfkill
[  799.213971] dell-laptop: setting up dell-bluetooth rfkill
[  799.214726] dell-laptop: max intensity is 7

Thanks.

-- 
Dmitry
