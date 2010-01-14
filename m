Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473Ab0ANS7C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab0ANS7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:59:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728Ab0ANS67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:58:59 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:18026 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab0ANS66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:58:58 -0500
Date: Thu, 14 Jan 2010 10:58:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 14 (vmwgfx)
Message-Id: <20100114105840.98972cbc.randy.dunlap@oracle.com>
In-Reply-To: <20100114172047.406ebda8.sfr@canb.auug.org.au>
References: <20100114172047.406ebda8.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B4F696B.01B9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 17:20:47 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100113:


When CONFIG_FB=m:

drivers/built-in.o: In function `vmw_fb_close':
(.text+0x9614a): undefined reference to `unregister_framebuffer'
drivers/built-in.o: In function `vmw_fb_close':
(.text+0x9616f): undefined reference to `framebuffer_release'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x965b6): undefined reference to `framebuffer_alloc'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x9692a): undefined reference to `register_framebuffer'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x9696a): undefined reference to `framebuffer_release'


so this driver needs to depend on FB (or select FB -- ugh, although
that's what nouveau does).

And these selects don't do anything when FB is not enabled:
	select FB_DEFERRED_IO
	select FB_CFB_FILLRECT
	select FB_CFB_COPYAREA
	select FB_CFB_IMAGEBLIT


---
~Randy
