Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbYGUIf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbYGUIf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbYGUIfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:35:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:32111 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYGUIfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Sunle7cqc5Cqm/9PnoigKXaAcQUqWdjFdtD6if4nIcAGepu23Sb7QwWJRJiVlpT4D/
         cwpMNSPaFp/g3C+tVRJL9PS4c9Gh0/uIojiH8r2aKgXw5J6uIDuhObyusxF21sIjpn0o
         5RtmzJiTbg/vq/If7CVadA8IbSLEQ7N9ZwPuM=
Date: Mon, 21 Jul 2008 12:35:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfs: use kstrdup()
Message-ID: <20080721083509.GB20011@lenovo>
References: <4881BEF4.2020201@cn.fujitsu.com> <20080719131317.GA7027@asus> <20080719131909.GB7027@asus> <20080721052713.GY28946@ZenIV.linux.org.uk> <48842CDB.1090009@cn.fujitsu.com> <20080721070346.GA28946@ZenIV.linux.org.uk> <20080721080427.GC6662@lenovo> <20080721082857.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721082857.GB28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Mon, Jul 21, 2008 at 09:28:57AM +0100]
| On Mon, Jul 21, 2008 at 12:04:27PM +0400, Cyrill Gorcunov wrote:
| >  		err = mnt_alloc_id(mnt);
| > -		if (err) {
| > -			kmem_cache_free(mnt_cache, mnt);
| > -			return NULL;
| > +		if (err)
| > +			goto err;
| 
| Ugh...  Labels are in a separate namespace, but really...
| 
| > +		if (name) {
| > +			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
| > +			if (!mnt->mnt_devname)
| > +				goto err;
| 
| > +err:
| > +	kmem_cache_free(mnt_cache, mnt);
| > +	return NULL;
| 
| Leak; note the mnt_alloc_id() above.  Either do that kstrdup() first and
| kfree the result on mnt_alloc_id() failure or do mnt_free_id() on kstrdup()
| one...
| 

oh my, that stupid from my side - will update shortly

		- Cyrill -
