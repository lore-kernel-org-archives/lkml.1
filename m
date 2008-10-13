Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbYJMX12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbYJMX12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbYJMX1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:27:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40681 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYJMX1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:27:19 -0400
Date: Mon, 13 Oct 2008 19:24:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, mcgrof@gmail.com
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081013232432.GB32550@tuxdriver.com>
References: <20081014010202.71d13eaf@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081014010202.71d13eaf@werewolf.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:02:02AM +0200, J.A. Magallón wrote:

> werewolf:~# modprobe ath5k
> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting ath5k (/lib/modules/2.6.27-jam03/kernel/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> werewolf:~# modprobe mac80211
> WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> FATAL: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
> 
> Dmesg is below.

cfg80211 isn't loading, so mac80211 can't find it's symbols, and
ath5k can't find mac80211's symbols.

> cfg80211: Unknown parameter `ieee80211_regdom'

config WIRELESS_OLD_REGULATORY
	bool "Old wireless static regulatory definitions"
	default n
	---help---
	  This option enables the old static regulatory information
	  and uses it within the new framework. This is available
	  temporarily as an option to help prevent immediate issues
	  due to the switch to the new regulatory framework which
	  does require a new userspace application which has the
	  database of regulatory information (CRDA) and another for
	  setting regulatory domains (iw).

	  For more information see:

	  http://wireless.kernel.org/en/developers/Regulatory/CRDA
	  http://wireless.kernel.org/en/users/Documentation/iw

	  It is important to note though that if you *do* have CRDA present
	  and if this option is enabled CRDA *will* be called to update the
	  regulatory domain (for US and JP only). Support for letting the user
	  set the regulatory domain through iw is also supported. This option
	  mainly exists to leave around for a kernel release some old static
	  regulatory domains that were defined and to keep around the old
	  ieee80211_regdom module parameter. This is being phased out and you
	  should stop using them ASAP.

	  Say N unless you cannot install a new userspace application
	  or have one currently depending on the ieee80211_regdom module
	  parameter and cannot port it to use the new userspace interfaces.

	  This is scheduled for removal for 2.6.29.

Is this not clear enough?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
