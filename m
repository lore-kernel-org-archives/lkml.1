Return-Path: <linux-kernel-owner+w=401wt.eu-S1753410AbXCWUVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbXCWUVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXCWUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:21:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7451 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbXCWUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d3vTQXr7HZetsZ5D6b8wEKHFsuP2zHSDrvlADOjHBG5tIPXz5KP2cSPB+ucgT/+1IbsO50rUUl0HwW5z7gAomAHjYp7lag0jwfljdAvPExplziB22jCraeSIsAWGR7udWIyDtl7aCaCaQuTDTpgY2uZlWzIdqJjZE7EQlAQUSNU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Olaf Hering <olaf@aepfle.de>
Subject: Re: request_queue_t depends on CONFIG_BLOCK
Date: Fri, 23 Mar 2007 21:29:29 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070322215234.GA13219@aepfle.de> <200703231929.19406.bzolnier@gmail.com> <20070323191428.GA23413@aepfle.de>
In-Reply-To: <20070323191428.GA23413@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703232129.29331.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 23 March 2007, Olaf Hering wrote:
> On Fri, Mar 23, Bartlomiej Zolnierkiewicz wrote:
> 
> > > Because it is needed in a few places.
> > 
> > Is there really any PPC64 specific code which needs <linux/ide.h>
> > (ppc_ide_md is used only by PPC32)?

I suspect that the answer to my question is "not really", if so then
shouldn't the problem that you've encountered be fixed with a one-line patch
which removes <linux/ide.h> include from arch/powerpc/kernel/setup_64.c?

Please try it.

> This is about CONFIG_BLOCK=n, not about arch/... Is all non-driver
> code which has to poke into ide code supposed to put an #ifdef
> CONFIG_IDE around #include <linux/ide.h>?

Such code is _broken_ (as you've just found out) by _implicitly_ depending
on CONFIG_IDE specific data structures and functions.  Please note that
<linux/ide.h> is CONFIG_IDE specific and CONFIG_IDE depends on CONFIG_BLOCK=y
so <linux/ide.h> should _not_ be included et all for CONFIG_BLOCK=n case...

PS IDE subsystem has allowed per arch/platform host drivers for years and if
somebody needs help in fixing the existing arch/... (ab)users of <linux/ide.h>
I'll be glad to provide it.

Thanks,
Bart
