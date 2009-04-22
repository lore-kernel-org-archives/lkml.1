Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbZDVJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbZDVJas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZDVJai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:30:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9292 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZDVJag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=cWXk8gBcCzwKNMw6BLGa6Nvifpg1r4emqqmQBWKbcqeXpDqUUMTq83v7GJipA2ey3F
         r5D6PNYa/L6Y4wvmdraqesUdS1G3H0LpnMwoOcu3fVqnsG7FtPO61ebuSDuLZEkL90Qg
         dzDOEYd61CHjkbFRmwecRQFU/29A1YA9P7jQs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [BUILD FAILURE 05/12] Next April 21 : PPC64 randconfig [drivers/macintosh/mediabay.o]
Date: Wed, 22 Apr 2009 11:34:17 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: subrata@linux.vnet.ibm.com, "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stefan Bader <stefan.bader@canonical.com>,
       Marcelo Tosatti <marcelo@conectiva.com.br>,
       Adrian Bunk <bunk@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
References: <1240339875.9110.137.camel@subratamodak.linux.ibm.com> <200904212104.14665.bzolnier@gmail.com> <18926.38431.910952.630575@cargo.ozlabs.ibm.com>
In-Reply-To: <18926.38431.910952.630575@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904221134.18163.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009 05:59:27 Paul Mackerras wrote:
> Bartlomiej Zolnierkiewicz writes:
> 
> > mediabay shouldn't include <linux/ide.h> unconditionally so
> > remove the superfluous include from mediabay.c (<asm/mediabay.h>
> > will pull <linux/ide.h> in for CONFIG_BLK_DEV_IDE_PMAC=y).
> 
> I don't like relying on second-hand imports like that.  I prefer the
> previous patch, that made mediabay depend on CONFIG_BLOCK.

I missed it somehow...

OK, I found it now and it should fix the problem as well.

> BTW, if including <linux/ide.h> causes an error when CONFIG_BLOCK=n,
> then there is a bug in <linux/ide.h>, IMO.

<linux/ide.h> is for drivers/ide only.  mediabay lacks proper abstraction
layer and is probably the only abuser left.

Besides being a build fix my patch is a right step in cleaning this mess
so I'm going to apply it through ide tree.

Thanks,
Bart
