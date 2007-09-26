Return-Path: <linux-kernel-owner+w=401wt.eu-S1759066AbXIZSej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066AbXIZSej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXIZSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:34:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39956 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359AbXIZSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:34:29 -0400
Date: Wed, 26 Sep 2007 20:34:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops
Message-ID: <20070926183449.GT6800@stusta.de>
References: <46F9E0EC.3010105@intel.com> <200709261340.l8QDeKie025351@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200709261340.l8QDeKie025351@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 09:40:20AM -0400, Erez Zadok wrote:
>...
> Also, Auke, if indeed compilers are [sic] likely to do better than
> programmers adding un/likely wrappers, then why do we still support that in
> the kernel?  (Working for a company tat produces high-quality compilers, you
> may know the answer better.)
> 
> Personally I'm not too fond of what those wrappers do the code: they make it
> a bit harder to read the code (yet another extra set of parentheses); and
> they cause the code to be indented further to the right, which you sometimes
> have to split to multiple lines to avoid going over 80 chars.

There are some places in generic code where it makes sense, e.g.:
  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)

If you run into a BUG() it's anyway game over.

And there are some rare hotpaths in the kernel where it might make 
sense, and many other places where the likely/unlikely usage that might 
be present doesn't make sense.

Unless you know you need it you simply shouldn't use likely/unlikely.

> Cheers,
> Erez.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

