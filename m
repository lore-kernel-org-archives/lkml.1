Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbYAWMfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbYAWMfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYAWMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:35:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:39371 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYAWMfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:35:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=uoW0AEyqyhJ8RUZilGQHNktQ5uHfmX4/x8mZ/X6/Ct/lqk4+cw7V5pUiZpTUU7qBFYu7NqkmTj2rtAvcf+FUkiZJxh0QrRsixrTAxGOuithquijiWxOZPAQ5raW7u6MLjoBIqQc0FJGNDHEIKGwaGwUF+VdyOX7cyjpQu5eJtNY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] ppc: fix #ifdef-s in mediabay driver
Date: Wed, 23 Jan 2008 13:47:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <200801230012.38516.bzolnier@gmail.com> <200801230158.42017.bzolnier@gmail.com> <1201061832.6807.64.camel@pasglop>
In-Reply-To: <1201061832.6807.64.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801231347.38853.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 January 2008, Benjamin Herrenschmidt wrote:
> 
> On Wed, 2008-01-23 at 01:58 +0100, Bartlomiej Zolnierkiewicz wrote:
> > I'm more worried about breaking automatic build checking (make randconfig)
> > than a few extra bytes so if you remove all #ifdefs you'll have to either
> > make BLK_DEV_IDE_PMAC select PMAC_MEDIABAY or make PMAC_MEDIABAY depend
> > on BLK_DEV_IDE_PMAC (otherwise BLK_DEV_IDE=n && PMAC_MEDIABAY=y will fail
> > since mediabay.c is referencing IDE code).
> 
> I was thinking about having the pmac arch code provide an exported
> function pointer to put the hook in to avoid that problem.

BTW the other pending IDE patches (yet to posted) include rework of IDE
hot-plug support for PMAC media-bay so ide_init_hwif_ports()/ide_register_hw()
/ide_unregister() calls in mediabay.c will be replaced by "something else".
