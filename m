Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab0CLWTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 17:19:44 -0500
Received: from c60.cesmail.net ([216.154.195.49]:56815 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab0CLWTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 17:19:43 -0500
Subject: Re: Weird wireless/wpa_supplicant screw-up.
From: Pavel Roskin <proski@gnu.org>
To: Valdis.Kletnieks@vt.edu
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <5220.1268430568@localhost>
References: <7197.1268086939@localhost>
	 <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 17:19:41 -0500
Message-Id: <1268432381.3596.12.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 16:49 -0500, Valdis.Kletnieks@vt.edu wrote:

> So the root cause has something to do with params[idx].cipher being unset.

Sorry if it's obvious, but please make sure you don't have another
wpa_supplicant running and there is no other software that tries to
control the interface.

If you have NetworkManager, the device in question should be unmanaged.
This could be done by adding this
to /etc/NetworkManager/nm-system-settings.conf:

[main]
plugins=keyfile

[keyfile]
unmanaged-devices=/org/freedesktop/Hal/devices/net_00_1f_11_01_06_55

If the "plugins" line exists, "keyfile" should be added, separated by
comma from the previous word.  The MAC address must be lowercase.
Entries on the unmanaged-devices line are separated by semicolons.

Use "cnetworkmanager -d" to make sure the device is unmanaged (install
cnetworkmanager if needed).  You may need to restart NetworkManager or
even reboot after changing the configuration.

Perhaps we need it in the FAQ somewhere.

-- 
Regards,
Pavel Roskin
