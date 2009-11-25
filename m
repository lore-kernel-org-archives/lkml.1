Return-Path: <linux-kernel-owner+w=401wt.eu-S964816AbZKYORX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816AbZKYORX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZKYORX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:17:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48264 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZKYORW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:17:22 -0500
Date: Wed, 25 Nov 2009 07:17:28 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Liuweni <qingshenlwy@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>,
       jack <jack@suse.cz>, npiggin <npiggin@suse.de>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       strongzgy <strongzgy@gmail.com>, xgr178 <xgr178@163.com>,
       Liu Hui <onlyflyer@gmail.com>
Subject: Re: [PATCH 2/3]fs/inode: iunique() Optimize Performance
Message-ID: <20091125141727.GI9482@parisc-linux.org>
References: <200911252212166092236@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911252212166092236@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 10:12:19PM +0800, Liuweni wrote:
> @@ -605,8 +605,8 @@ static unsigned long hash(struct super_block *sb, unsigned long hashval)
>  {
>  	unsigned long tmp;
>  
> -	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
> -			L1_CACHE_BYTES;
> +	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) >>
> +			L1_CACHE_SHIFT;
>  	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> I_HASHBITS);
>  	return tmp & I_HASHMASK;
>  }

Have you compared the compiler output before/after your change?  I'd be
amazed if GCC isn't able to optimise division-by-a-constant-power-of-two
into shift-by-constant.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
