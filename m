Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbYCUVRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbYCUVRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbYCUVR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:17:29 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56325 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbYCUVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:17:28 -0400
To: haveblue@us.ibm.com
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
In-reply-to: <1206133681.30471.37.camel@nimitz.home.sr71.net> (message from
	Dave Hansen on Fri, 21 Mar 2008 14:08:01 -0700)
Subject: Re: r-o bind in nfsd
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
	 <20080321155451.GU10722@ZenIV.linux.org.uk>
	 <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu>
	 <20080321163520.GV10722@ZenIV.linux.org.uk>
	 <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu>
	 <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
	 <20080321181105.GW10722@ZenIV.linux.org.uk>
	 <E1JcmLz-0001n1-RC@pomaz-ex.szeredi.hu> <1206133681.30471.37.camel@nimitz.home.sr71.net>
Message-Id: <E1Jcobn-00029d-Vd@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Mar 2008 22:17:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2008-03-21 at 19:52 +0100, Miklos Szeredi wrote:
> > Traditionally we have syscalls, and nfsd.  Both of them want the
> > security checks, and I think nfsd wants the read-only mount checking
> > as well, but I'm not entirely sure.  Maybe we can handle that by just
> > making nfsd acquire a write-ref on the mount and keep it while it's
> > exported.
> 
> The only question for me would be where the current r/o checks are
> happening (IS_RDONLY()).  I generally based my patches on replacing
> those calls.  

In may_create()/may_delete() on parent directory.  So that one needs
audit of all callers, unless Al can be convinced that moving those
checks into the VFS makes sense.

Miklos
