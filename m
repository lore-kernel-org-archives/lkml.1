Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZF2JvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZF2JvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZF2JvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:51:09 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36883 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbZF2JvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:51:08 -0400
Subject: Re: kmemleak reports firmware loader funnies in iwlwifi
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <84144f020906290248w474ad2ffpe6a8b5bede3d2c20@mail.gmail.com>
References: <20090626171933.GA23170@redhat.com>
	 <tnxy6rbv0oq.fsf@pc1117.cambridge.arm.com>
	 <84144f020906290248w474ad2ffpe6a8b5bede3d2c20@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 29 Jun 2009 10:50:55 +0100
Message-Id: <1246269055.21450.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2009 09:50:56.0166 (UTC) FILETIME=[191E1460:01C9F89F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 12:48 +0300, Pekka Enberg wrote:
> Hi Catalin,
> 
> On Mon, Jun 29, 2009 at 12:39 PM, Catalin
> Marinas<catalin.marinas@arm.com> wrote:
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index ddeb819..26fb808 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -179,6 +179,13 @@ static ssize_t firmware_loading_store(struct device *dev,
> >                                dev_err(dev, "%s: vmap() failed\n", __func__);
> >                                goto err;
> >                        }
> > +                       /*
> > +                        * This block of memory is later freed using vfree.
> > +                        * Since kmemleak does not track vmap calls, just
> > +                        * inform it about this block but ignore it during
> > +                        * scanning.
> > +                        */
> > +                       kmemleak_alloc(fw_priv->fw->data, 0, -1, GFP_KERNEL);
> >                        /* Pages will be freed by vfree() */
> >                        fw_priv->pages = NULL;
> >                        fw_priv->page_array_size = 0;
> 
> Would it be possible to put this hook in vmap() somehow?

It can be (and it could track vmap leaks as well). BTW, is there any
use-case where vmap'ed memory may contain pointers? I did a grep but
none of the vmap'ed blocks seem to have pointers.

-- 
Catalin

