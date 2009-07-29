Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbZG2BbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbZG2BbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 21:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbZG2BbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 21:31:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:57833 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbZG2BbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 21:31:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,285,1246863600"; 
   d="scan'208";a="478810898"
Subject: Re: 31-rc3-mmotm0716 - wonky wireless statistics..
From: Zhu Yi <yi.zhu@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <5934.1248814870@turing-police.cc.vt.edu>
References: <5934.1248814870@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 09:31:18 +0800
Message-Id: <1248831078.3747.1117.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 05:01 +0800, Valdis.Kletnieks@vt.edu wrote:
> Dell Latitude D820 laptop, lspci reports the network card as:
> 
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Netwo           rk Connection (rev 02)
> 
> iwlwifi driver in use, card associated via wpa_supplicant but not being
> actively used
> 
> # iwconfig
> wlan0     IEEE 802.11abg  ESSID:"VT-Wireless"  
>           Mode:Managed  Frequency:2.447 GHz  Access Point: 00:11:20:A4:4C:10   
>           Bit Rate=54 Mb/s   Tx-Power=15 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:<lopped out> [2]
>           Link Quality=62/70  Signal level=-48 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> # cat /proc/net/wireless
> Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
>  face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
>  wlan0: 0000   63.  -47.  -256        0      0      0      0      0        0
>  wlan1: 0000    0     0     0        0      0      0      0      0        0
>  wlan2: 0000    0     0     0        0      0      0      0      0        0
> 
> Where did that -256 for "noise" come from?  It ends up confusing the
> gkrellm-wifi plugin, it reports a S/N of 219dB ;)

This should be related to http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=fdb897ea5c77836f890033d563336ab0c94c9222

But I don't think this is an ABI broken. User space should parse the
trailing '.' to see if a field is updated or not because there are cards
not capable to report hardware noise level anyway. Johannes?

Thanks,
-yi

