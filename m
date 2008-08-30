Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYH3Owe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYH3Owe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYH3OwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:52:25 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54749 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYH3OwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:52:24 -0400
Date: Sat, 30 Aug 2008 23:52:26 +0900 (JST)
Message-Id: <20080830.235226.108118828.anemo@mba.ocn.ne.jp>
To: david@fries.net
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, netdev@vger.kerne.org
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080830022749.GF17528@spacedout.fries.net>
References: <20080828041110.GA9404@spacedout.fries.net>
	<20080830.002215.128620618.anemo@mba.ocn.ne.jp>
	<20080830022749.GF17528@spacedout.fries.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 21:27:49 -0500, David Fries <david@fries.net> wrote:
> > With your patch, cleanup_module() and ne_exit() is exactly same.  How
> > about unifying them?
> 
> They didn't use to be the same, with all the cleanup I didn't notice
> that they became the same.  ne_exit is no more, cleanup_module for
> both module and built in.

The name "cleanup_module" is special.  I think this should not be used
outside #ifdef MODULE.  Please rename it something like
ne_cleanup_module() and make it static.  Or just use ne_exit().

> > This .name initialization seems a bit redundant for me.  They can be
> > left NULL.
> 
> Changed.

Thanks.  You killed two .name and there are still two .name in ne_probe.

---
Atsushi Nemoto
