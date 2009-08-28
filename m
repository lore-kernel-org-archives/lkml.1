Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbZH1O31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbZH1O31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 10:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZH1O30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 10:29:26 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:65312 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbZH1O30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 10:29:26 -0400
Date: Fri, 28 Aug 2009 23:24:29 +0900 (JST)
Message-Id: <20090828.232429.106266868.anemo@mba.ocn.ne.jp>
To: wim@iguana.be
Cc: roel.kluin@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, teheo@suse.de
Subject: Re: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after
 errors
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090827201317.GH29382@infomag.iguana.be>
References: <4A93ACDA.8030000@gmail.com>
	<20090827.235200.21363768.anemo@mba.ocn.ne.jp>
	<20090827201317.GH29382@infomag.iguana.be>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 22:13:17 +0200, Wim Van Sebroeck <wim@iguana.be> wrote:
> > > Make txx9wdt_probe() clean up after errors.
> > > 
> > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > ---
> > > Any comments?
> > 
> > Well, why is this patch needed?  I intentionally omitted iounmap and
> > release_mem_region because devres guarantee these resources are freed
> > on probe failure.  Or are there any leaks?
> 
> My opinion: a driver should do proper clean-up on probe failures because
> 1) this makes clean and robust code and shows that you know what you are doing
> 2) to avoid having to search for leaks if there are any. See the NULL pointer story...

I think "proper clean-up" in this case is "do nothing for
devres-managed resources".  An example in
Documentation/driver-model/devres.txt clearly say so.  Actually most
drivers do not call devm_iounmap in any case.

Also, the patch added devm_iounmap in failure path but not in exit
path.  This looks inconsistent.

---
Atsushi Nemoto
