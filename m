Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYCZQiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYCZQiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYCZQhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:37:47 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:41101 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbYCZQhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:37:47 -0400
Date: Thu, 27 Mar 2008 01:37:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin Watchdog Driver: split platform device/driver registering from actual watchdog device/driver registering so we can cleanly load/unload
Message-ID: <20080326163736.GA12632@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bryan Wu <cooloney@kernel.org>, wim@iguana.be,
	linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
References: <1206581401-26046-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206581401-26046-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 06:30:01PM -0700, Bryan Wu wrote:
> +#define pr_devinit(fmt, args...) ({ static const __devinitdata char __fmt[] = fmt; printk(__fmt, ## args); })
>  #define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
>  
WTF? You are trying to micro-optimize the string? And you have a printk
that changes behaviour if you have hotplug enabled or not. That's so
utterly bizarre that the rationale must be fascinating.

pr_xxx() also is a protected namespace that belongs in
include/linux/kernel.h, though I can see why you opted to hide these in
your driver rather than post them for general inclusion.

If you are hurting that badly for space, just turn off CONFIG_PRINTK and
move on with life. This is just insane.
