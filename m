Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZIVXkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZIVXkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIVXkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:40:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:44121 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZIVXkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RW1rcUnWjqQ047JsI3eEpJofiYTZMN42Vk7BV9WhgSvfo4vQTeX1NhU3DD+phfs3WX
         27OpKwb/xng0j+kSQ9dKRnhE1shrALb39IQwqBbzdO3y2DZZQwCgjwVIuUWqVvtSMgQg
         c7bFCePMJWXd8Grt9CEKZs12fo/ekk6qMotHA=
Date: Wed, 23 Sep 2009 03:40:16 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       dbrownell@users.sourceforge.net, dwmw2@infradead.org,
       dedekind1@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] mtd: m25p80: Add support for CAT25xxx serial
 EEPROMs
Message-ID: <20090922234016.GA1021@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru>
 <20090818214628.GB22651@oksana.dev.rtsoft.ru>
 <20090922162548.3e20e67c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090922162548.3e20e67c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:25:48PM -0700, Andrew Morton wrote:
> On Wed, 19 Aug 2009 01:46:28 +0400
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > CAT25 chips (as manufactured by On Semiconductor, previously Catalyst
> > Semiconductor) are similar to the original M25Px0 chips, except:
> > 
> > - Address width can vary (1-2 bytes, in contrast to 3 bytes in M25P
> >   chips). So, implement convenient m25p_addr2cmd() and m25p_cmdsz()
> >   calls, and place address width information into flash_info struct;
> > 
> > - Page size can vary, therefore we shouldn't hardcode it, so get rid
> >   of FLASH_PAGESIZE definition, and place the page size information
> >   into flash_info struct;
> > 
> > - CAT25 EEPROMs don't need to be erased, so add NO_ERASE flag, and
> >   propagate it to the mtd subsystem.
> 
> This patch (still) doesn't know about the mx25l3205d, mx25l12805d and
> mx25l12855e devices.

Yes, support for these chips commited on Fri, 4 Sep 2009 08:40:27
+0000 (09:40 +0100). And the patch dated 19 Aug.

> I randomly did this:
> 
> ->	{ "mx25l3205d", INFO(0xc22016, 0, 64 * 1024, 64, 256, 3, 0) },
> ->	{ "mx25l6405d", INFO(0xc22017, 0, 64 * 1024, 128, 256, 3, 0) },
> 	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 256, 3, 0) },
> ->	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 256, 3, 0) },

Looks correct, thanks a lot.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
