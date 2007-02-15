Return-Path: <linux-kernel-owner+w=401wt.eu-S1030733AbXBOTUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030733AbXBOTUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030731AbXBOTUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:20:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:9889 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030730AbXBOTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:20:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=pqDQFGSiF2PCb4frSX8dlUpFk8vouj/hfiGp62hqCQkNWdeCl/LTY/P1Gi4jqAjsCq3LLJvNRqGWC7YG4IKFUwTp4lJeO49qVhKKT2Gamw8BVuz5aIo+m7WVyK8yWFirD0h6d7yctEuufSx7QpSwogPhs9wteQ8KnW8T8DLGgig=
Date: Thu, 15 Feb 2007 22:17:16 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@osdl.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HIL: fix improper call of release_region
Message-ID: <20070215191716.GB12012@cvg>
References: <20070215175031.GA12012@cvg> <200702151954.33474.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702151954.33474.deller@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 07:54:33PM +0100, Helge Deller wrote:
| Hi Cyrill,
| 
| please include the "err1" label as well inside the #if / #endif clause.
| err1 is used only when CONFIG_HP300 is defined and in the parisc-case you currently get an unused label warning...
| 
| Helge
| 
| On Thursday 15 February 2007, Cyrill V. Gorcunov wrote:
| > Thist patch prevents from improper call of release_region
| > if the code has been compiled without CONFIG_HP300 support.
| > 
| > Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
| > 
| > ---
| > 
| >  drivers/input/keyboard/hilkbd.c |    2 ++
| >  1 files changed, 2 insertions(+), 0 deletions(-)
| > 
| > diff --git a/drivers/input/keyboard/hilkbd.c b/drivers/input/keyboard/hilkbd.c
| > index 255a6ec..c3c0da3 100644
| > --- a/drivers/input/keyboard/hilkbd.c
| > +++ b/drivers/input/keyboard/hilkbd.c
| > @@ -294,7 +294,9 @@ err3:
| >  	disable_irq(HIL_IRQ);
| >  	free_irq(HIL_IRQ, hil_dev.dev_id);
| >  err2:
| > +#if defined(CONFIG_HP300)
| >  	release_region(HILBASE + HIL_DATA, 2);
| > +#endif
| >  err1:
| >  	input_free_device(hil_dev.dev);
| >  	hil_dev.dev = NULL;
| > 
| 
| 

Indeed. Give me a minute. (Damn, how could I get a such mistake ;)

-- 

		Cyrill

