Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZJ0JMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZJ0JMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 05:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932219AbZJ0JMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 05:12:09 -0400
Received: from sh.osrg.net ([192.16.179.4]:33543 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbZJ0JMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 05:12:08 -0400
Date: Tue, 27 Oct 2009 18:11:11 +0900
To: JBeulich@novell.com
Cc: mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de, tiwai@suse.de,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, hpa@zytor.com
Subject: Re: [PATCH] x86: adjust GFP mask handling for coherent	 allocations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4AE6C4D3020000780001BF13@vpn.id2.novell.com>
References: <4AE5D238020000780001BD46@vpn.id2.novell.com>
	<20091026201917.GE24682@elte.hu>
	<4AE6C4D3020000780001BF13@vpn.id2.novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091027181053L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 18:11:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 08:58:14 +0000
"Jan Beulich" <JBeulich@novell.com> wrote:

> >Well, in the first place, we don't need the #ifdef in Jan's patch. We
> >can always use DMA_BIT_MASK(24) for the fallback device.
> 
> But this one I don't agree with - the purpose of the patch is to not have
> a 24-bit (or 32-bit) mask here unconditionally: It would result in GFP_DMA
> to be forced on for the allocation (which the patch specifically eliminates),

If a driver doesn't want to GFP_DMA, it should set up the
dma_coherent_mask of the device and pass it. In fact, it should do. A
driver that uses the fallback device is broken.

Why can't you fix drivers that use the fallback instead of adding
another hack to the common place?
