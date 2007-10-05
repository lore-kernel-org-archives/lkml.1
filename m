Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbXJELdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbXJELdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXJELdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:33:37 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:46467 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXJELdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:33:37 -0400
To: wfg@mail.ustc.edu.cn
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, gregkh@suse.de,
       akpm@linux-foundation.org
In-reply-to: <391582087.27602@ustc.edu.cn> (message from Fengguang Wu on Fri,
	5 Oct 2007 19:01:23 +0800)
Subject: Re: BUG on unloading the fuse module
References: <391574553.18064@ustc.edu.cn> <E1Idjd8-0002rY-00@dorka.pomaz.szeredi.hu> <391581094.26735@ustc.edu.cn> <E1Idkor-0002v6-00@dorka.pomaz.szeredi.hu> <391582087.27602@ustc.edu.cn>
Message-Id: <E1IdlQc-0002wt-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 05 Oct 2007 13:33:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > In 2.6.23-rc8-mm2, the fuse module always bugs on unloading.
> > > > 
> > > > It's fixed in Greg's patch queue.
> > > > 
> > > > This patch against -mm will also fix it.
> > > 
> > > Oh no, it panics:
> > 
> > How about this one?
> 
> Yes, it did the trick.

Thanks.

It seems, some kobject ->release() function is freeing kobj->k_name,
so we need to free it, and set it to NULL _before_ calling
->release().

Greg, can you please fix that in your queue?

Miklos
