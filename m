Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYGDNSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYGDNSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYGDNSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:18:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYGDNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:18:06 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jeff@garzik.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org
In-Reply-To: <s5hmykxc3ja.wl%tiwai@suse.de>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	 <20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <486CC440.9030909@garzik.org>
	 <Pine.LNX.4.64.0807031353030.11033@blonde.site>
	 <s5hmykxc3ja.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 14:17:51 +0100
Message-Id: <1215177471.10393.753.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 13:06 +0200, Takashi Iwai wrote:
> Hmm, I got this error even with CONFIG_FIRMWARE_IN_KERNEL=y.
> 
> Through a quick look at the code, the firmwares are not built indeed.
> I guess the fix like the following needed for building firmwares for
> modules.  Now trying to build the kernel again to check this...

For modules, you just need run
	'make INSTALL_FW_PATH=/lib/firmare firmware_install'.

I should...

1. Change the default to /lib/firmware so that you don't have to set
   INSTALL_FW_PATH.
2. Add that to the 'make help' text.
3. Look at making 'make modules_install' installl the firmware required
   by the modules it's installing, so you don't even need to do
   _anything_ new.

-- 
dwmw2

