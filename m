Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbXEPW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbXEPW7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbXEPW7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:59:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:36098 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbXEPW7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=chQ//803eRW5JyEb8P36fq4c1+dBzK7Qp6D0tC05xO7unoqlGIfw1ZlHaYa8I31IK4K4yxYHAw97S3vKMjV19eLO2MufTU6CD4ttcVKvN5iS1uN6KlRs5OX6DOrywLPumE+Swil+hg9d3UzCGIKBDN+TY35/aqGBCpOwzZfAqcY=
Subject: Re: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to
	their respective subdirectories
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@osdl.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070516.145317.03979683.davem@davemloft.net>
References: <464B78BC.4080900@gmail.com>
	 <20070516.145317.03979683.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 17 May 2007 06:59:05 +0800
Message-Id: <1179356345.4743.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 14:53 -0700, David Miller wrote:
> From: "Antonino A. Daplas" <adaplas@gmail.com>
> Date: Thu, 17 May 2007 05:33:48 +0800
> 
> > Move arch-specific bits of fb_mmap() to their respective subdirectories
> > 
> > Signed-off-by: Antonino Daplas <adaplas@gmail.com>
> > ---
> > Hi all,
> > 
> > Please let me know if there are mistakes with this patch.
> 
> Thank you for doing this work.
> 
> __sparc_v9__ means CONFIG_SPARC64, if that is not defined it's
> CONFIG_SPARC32, so you could simplify this patch a lot.
> 
> 1) Remove __sparc_v9__ ifdefs from asm-sparc64/fb.h
> 2) Define fb_mmap_required() to return 0 in asm-sparc64/fb.h
> 3) Define fb_mmap_required() to return 1 in asm-sparc/fb.h
> 4) Remove all the sparc ifdef stuff you added to linux/fb.h
> 5) There won't be a default fb_mmap_required() provided by
>    linux/fb.h on platforms other than sparc ones, you'll need
>    to provide one in order for the build to work non-sparc since
>    this call is unconditional in fbmem.c:
> 
> +	if (fb_mmap_required())
> +		return -EINVAL;
> 
> With those fixes:
> 

Okay, I see what you mean.  I will concoct another patch later.

Tony


