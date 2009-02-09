Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZBIBis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZBIBis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZBIBig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:38:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58990 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZBIBid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:38:33 -0500
Message-ID: <498F890C.2030300@jp.fujitsu.com>
Date: Mon, 09 Feb 2009 10:38:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI/MSI: fix msi_mask()
References: <498A5348.3090508@jp.fujitsu.com> <20090208112650.GD31509@parisc-linux.org>
In-Reply-To: <20090208112650.GD31509@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Feb 05, 2009 at 11:47:36AM +0900, Hidetoshi Seto wrote:
>> This patch fix the wrong array in the msi_mask().
> 
> Quite correct.  While disconnected for a couple of weeks, I also
> considered this possible fix:
> 
> static inline __attribute_const__ u32 msi_mask(unsigned x)
> {
>         /* Don't shift by >= width of type */
>         if (x >= 5)
>                 return 0xffffffff;
>         return (1 << (1 << x)) - 1;
> }
> 
> which has the added bonus of not running off the end of the array if
> some device has a bogus value in its config space.
> 
> What do you think?

Yeah, I think it's better one.
I'm going to post a revised patch hiring this style.

Thanks,
H.Seto

