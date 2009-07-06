Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZGFC3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZGFC3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 22:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZGFC3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 22:29:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:39812 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZGFC3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 22:29:13 -0400
Date: Mon, 6 Jul 2009 11:28:32 +0900
To: tom.leiming@gmail.com
Cc: arnd@arndb.de, joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090705204418.44fc38c1@linux-lm>
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
	<200907051319.37169.arnd@arndb.de>
	<20090705204418.44fc38c1@linux-lm>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090706112811A.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 06 Jul 2009 11:28:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 20:44:18 +0800
Ming Lei <tom.leiming@gmail.com> wrote:

> On Sun, 5 Jul 2009 13:19:36 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Saturday 04 July 2009, tom.leiming@gmail.com wrote:
> > > 2,Disabling CONFIG_HAVE_DMA_ATTRS may lead to a compile failure;
> > 
> > I'm not sure I understand this point. CONFIG_HAVE_DMA_ATTRS tells
> > the common code whether the architecture understands dma attributes.
> 
> If a new arch does not define CONFIG_HAVE_DMA_ATTRS but uses
> dma-mapping-common.h, it will lead to a compile failure. 

Yeah, architectures that use dma-mapping-common.h need to define
CONFIG_HAVE_DMA_ATTRS because dma-mapping-common.h needs to handle
architectures that need CONFIG_HAVE_DMA_ATTRS.


Your idea doesn't sound good to me.

I think that it's better to define CONFIG_HAVE_DMA_ATTRS in the
consistent way; defining arch's Kconfig. Defining
CONFIG_HAVE_DMA_ATTRS in two different ways and inventing another
define such as ARCH_USE_DMA_MAPPING_COMMON is just confusing.
