Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0BPIlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:41:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48003 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0BPIlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:41:14 -0500
Date: Tue, 16 Feb 2010 09:41:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nameer Yarkon <nameer.yarkon@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Robert Hancock <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20100216084110.GK21783@one.firstfloor.org>
References: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:35:40AM +0200, Nameer Yarkon wrote:
> On Thu, Nov 12, 2009 at 8:13 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> Is that the only valid use of /dev/mem, or even its main use?
> >
> > These days it is the primary use. Things like X11 were historically
> > probably the biggest user of it, and things like LRMI sometimes need that
> > sort of stuff.
> 
> how does X11 get now direct access to the physical memory (instead of
> /dev/mem) ?

The classic X server doesn't use main memory, typically just mapped
graphic card resources
(if you don't count BIOS tables and memory accessed by the video bios
running in emulation, but that is typically excluded by the check)  

In fact it can't because it doesn't know the physical
addresses of its process memory.

Modern X does it through kernel modules (DRM, GEM etc.)

One reason it's needed to do it this way is IOMMUs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
