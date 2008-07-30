Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbYG3UJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbYG3UJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYG3UJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:09:12 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:42553 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbYG3UJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:09:11 -0400
X-BigFish: VPS-25(z37d4l34a4l518kz1432R98dR4015M1805M655Ozz10d3izzz2fh6bh66h)
X-Spam-TCS-SCL: 5:0
Message-ID: <4890CB06.9040106@am.sony.com>
Date: Wed, 30 Jul 2008 13:11:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>
CC: Marco Berizzi <pupilla@hotmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: commit a29ccf6f823a84d89e1c7aaaf221cf7282022024 break console
 on slackware 12.1
References: <BAY103-DAV4F0ECBCAFB86B24C87D3EB2820@phx.gbl> <200807291815.13907.alistair@devzero.co.uk> <BAY103-W38794846AA924235B38E47B2820@phx.gbl> <488FAFE3.4040001@am.sony.com> <ntcv845p7kpiob7iqf6d1m8buj116ug4nv@4ax.com>
In-Reply-To: <ntcv845p7kpiob7iqf6d1m8buj116ug4nv@4ax.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 20:08:57.0302 (UTC) FILETIME=[1939E760:01C8F280]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady wrote:
> I have the same issue, the line drawing characters are displayed as an odd 
> looking C with a tail.  Slackware-12.1 and Slamd64-12.1.
> 
> .configs:
>   http://bugsplatter.mine.nu/test/boxen/pooh/config-2.6.27-rc1a.gz
>   http://bugsplatter.mine.nu/test/boxen/pooh64/config-2.6.27-rc1a.gz
> 
> CONFIG_CONSOLE_TRANSLATIONS=y ?? yes it's on

This looks like an operator precedence bug introduced by
the patch.

Normally I would test this myself before sending it out, but
I can't test 2.6.27-rc1 right now on my hardware due to another
bug in the 2.6.27-rc1 tree.

Can you please try the following patch and let me know if that
fixes the problem?

Thanks,
 -- Tim

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 14c0e91..8c8119f 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -74,7 +74,7 @@ void con_protect_unimap(struct vc_data *vc, int rdonly);
 int con_copy_unimap(struct vc_data *dst_vc, struct vc_data *src_vc);

 #define vc_translate(vc, c) ((vc)->vc_translate[(c) |			\
-					(vc)->vc_toggle_meta ? 0x80 : 0])
+					((vc)->vc_toggle_meta ? 0x80 : 0)])
 #else
 #define con_set_trans_old(arg) (0)
 #define con_get_trans_old(arg) (-EINVAL)



