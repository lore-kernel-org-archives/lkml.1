Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbYLZGuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbYLZGuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 01:50:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZGtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 01:49:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36213 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYLZGtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 01:49:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] coredump_filter: enable to change the default filter
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
In-Reply-To: <49547836.7040907@hitachi.com>
References: <20081219195311.81C4AFC351@magilla.sf.frob.com> <49547836.7040907@hitachi.com>
Message-Id: <20081226153931.5CBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Fri, 26 Dec 2008 15:49:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>However, we would need a special care for PID namespace if we use
> >>init's coredump_filter as default.  For a process with new PID
> >>namespace and new /proc, writing to /proc/1/coredump_filter doesn't
> >>mean changing default, although it's not a usual operation.
> > 
> > I'd figured that private PID namespaces with their own init would want
> > their own private settings for this default too.
> 
> Probably it's true, but I'm not sure if having coredump_filter have
> two means is acceptable.  init in a private PID namespace can die
> and dump a core file.  So its coredump_filter has two means; default
> setting for the namespace and setting for itself.  

FWIW, I think private namespace should have private settings framework.
I don't like to make special private settings code in this patch.

Yeah, defenitely we need to private settings for various reason, I agreed.
but we also need consistent private settings rule and framework.
otherwise, we will make various non consistent crap. maybe..



