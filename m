Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbXLDBPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbXLDBPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLDBPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:15:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:32927 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXLDBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fkt1khmn3Y4LHqHlKKDS1G9aPW1G+x4KWkNf97syo1oy2gsiJt3WWy7imofzkJ4v/D4rcb726YVy6rHayWEaNBgXJtBObDLrOVf17yS8Lkf212RhDvQ6PHxS7ASZdwUsvRjXBoCqNxbXl56oCqjB4xkKcAxaoXU6geQr51CnSbA=
Date: Tue, 4 Dec 2007 09:15:40 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, yakui.zhao@intel.com,
       Chris Holvenstot <cholvenstot@comcast.net>,
       linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com, trenn@suse.de,
       Andrew Morton <akpm@osdl.org>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Message-ID: <20071204011540.GA2713@darkstar.lan>
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl> <475436A3.90906@keyaccess.nl> <1196729713.13969.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196729713.13969.1.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 08:55:13AM +0800, Shaohua Li wrote:
> 
> On Mon, 2007-12-03 at 18:02 +0100, Rene Herman wrote:
> > On 30-11-07 23:22, Rene Herman wrote:
> > 
> > > On 30-11-07 14:14, Chris Holvenstot wrote:
> > > 
> > >> For what it is worth I too have seen this problem this morning and it
> > >> DOES appear to be new (in contrast to a previous comment)
> > >>
> > >> The message:  pnpacpi: exceeded the max number of mem resources: 12
> > >>
> > >> is displayed each time the system is booted with the 2.6.24-rc3-git5
> > >> kernel but is NOT displayed when booting 2.6.24-rc3-git4
> > >>
> > >> I have made no changes in my config file between these two kernels other
> > >> than to accept any new defaults when running make oldconfig.
> > >>
> > >> If you had already narrowed it down to a change between git4 and git5 I
> > >> apologize for wasting your time.  Have to run to work now.
> > > 
> > > Thanks, and re-added the proper CCs. Sigh...
> > > 
> > > Well, yes, the warning is actually new as well. Previously your kernel 
> > > just silently ignored 8 more mem resources than it does now it seems.
> > > 
> > > Given that people are hitting these limits, it might make sense to just 
> > > do away with the warning for 2.6.24 again while waiting for the dynamic 
> > > code?
> > 
> > Ping. Should these warnings be reverted for 2.6.24?
> Revert the warning doesn't make any sense. I'd suggest changing the IO
> resources number bigger till Thomas's patch in.
Agree.
Change it to 90 works for me, But I think maybe 128 is better.

include/linux/pnp.h |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux/include/linux/pnp.h linux.new/include/linux/pnp.h
--- linux/include/linux/pnp.h	2007-12-04 09:09:23.000000000 +0800
+++ linux.new/include/linux/pnp.h	2007-12-04 09:09:40.000000000 +0800
@@ -13,7 +13,7 @@
 #include <linux/errno.h>
 #include <linux/mod_devicetable.h>
 
-#define PNP_MAX_PORT		24
+#define PNP_MAX_PORT		128
 #define PNP_MAX_MEM		12
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
