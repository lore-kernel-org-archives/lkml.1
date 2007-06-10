Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbXFJRut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbXFJRut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXFJRum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:50:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41790 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbXFJRul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:50:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:subject:date:user-agent:cc:mime-version:content-disposition:to:content-type:content-transfer-encoding:message-id;
        b=QneYKHbuy2ilnzGQaQZMxiBT+INeBjKVrjMcH+4sUB/PEN9lxLwKtcMhk9t1eSfZEyo6rgnGhjF1Bc1VUcBQf53/inFgo79E8NChk/ztIcU9t65oVMLv2jfE/E2DqAgEvv/9iM3xt3k6smO5WwkJEfmDcSWAOQcUKl+aqUyxc40=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton@gmail.com>
Subject: Re: v2.6.21.4-rt11
Date: Sun, 10 Jun 2007 19:50:32 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
To: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200706101950.32278.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 15:17, Ingo Molnar wrote:
> -rt11 is a bit more experimental than usual: it includes the CFS 
> scheduler.

Great! Finally CFS is included ;)

Right now I'm using a patched kernel (2.6.21.4) with realtime-preemption patch 
and it works fine but I noticed something that I think you should know.

There's a problem with mac80211. I'm using "mac80211-8.0.1" 
and "iwlwifi-0.0.25" driver with my "Intel Pro Wireless 3945ABG" card.
When loading the "iwl3945" module or when an application (like wpa_supplicant, 
dhcpcd...) tries to do something with the card, I get this message in dmesg:

BUG: using smp_processor_id() in preemptible [00000000] code: 
wpa_supplicant/11659
caller is ieee80211_set_multicast_list+0x40/0x163 [mac80211]
 [<c0213b1d>] debug_smp_processor_id+0xad/0xb0
 [<f8e860bc>] ieee80211_set_multicast_list+0x40/0x163 [mac80211]
 [<c02e8532>] __dev_mc_upload+0x22/0x23
 [<c02e8686>] dev_mc_upload+0x24/0x37
 [<c02e52f5>] dev_change_flags+0x26/0xf6
 [<c031fc5e>] devinet_ioctl+0x539/0x6aa
 [<c02db972>] sock_ioctl+0xa2/0x1d5
 [<c02db8d0>] sock_ioctl+0x0/0x1d5
 [<c018500f>] do_ioctl+0x1f/0x6d
 [<c01850ad>] vfs_ioctl+0x50/0x273
 [<c0185304>] sys_ioctl+0x34/0x50
 [<c01040c6>] sysenter_past_esp+0x5f/0x85
 [<c0340000>] pfkey_add+0x7c7/0x8d9
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c0213ac4>] .... debug_smp_processor_id+0x54/0xb0
.....[<00000000>] ..   ( <= _stext+0x3fefed0c/0xc)

Anyway, the wifi card works fine.

I got rid of this message by commenting the code of the 
function "ieee80211_set_multicast_list()" that's 
on "net/mac80211/ieee80211.c" but this isn't a proper fix.

I think you should know about this because kernel 2.6.22 already includes 
mac80211.

Greetings.

-- 
Miguel Botón
