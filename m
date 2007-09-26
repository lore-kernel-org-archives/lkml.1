Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXIZS72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXIZS72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbXIZS7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:59:21 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:36685 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbXIZS7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:59:21 -0400
To: haveblue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-reply-to: <1190830135.30530.32.camel@localhost> (message from Dave Hansen
	on Wed, 26 Sep 2007 11:08:55 -0700)
Subject: Re: missing mnt_drop_write() on open error
References: <E1IaJc0-000541-00@dorka.pomaz.szeredi.hu>
	 <1190769669.26982.325.camel@localhost>
	 <E1IaSPW-0005M4-00@dorka.pomaz.szeredi.hu>
	 <1190823545.30530.19.camel@localhost>
	 <E1Iab1W-0005Ye-00@dorka.pomaz.szeredi.hu> <1190830135.30530.32.camel@localhost>
Message-Id: <E1Iac1o-0005bH-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 20:54:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Btw, may_open() doesn't do mnt_want_write() around the truncation if
> > file is opened with O_TRUNC | O_RDONLY.
> 
> What's the path to may_open() in that case?  open_namei() should wrap
> all callers other than nfs, and it does:
> 
> 	/* O_TRUNC implies we need access checks for write permissions */
>         if (flag & O_TRUNC)
>                 acc_mode |= MAY_WRITE;
> 
> Which should trigger the may_open() code.  

Ah, I missed that.

Thanks,
Miklos
