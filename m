Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYJPWgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYJPWgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYJPWgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:36:42 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:6192 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbYJPWgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:36:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJJe90h5LF1j/2dsb2JhbADEJINs
X-IronPort-AV: E=Sophos;i="4.33,426,1220193000"; 
   d="scan'208";a="232258871"
Date: Fri, 17 Oct 2008 09:36:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Tim Shimmin <tes@sgi.com>, stable@kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: [PATCH] XFS fix remount rw with unrecognized options
Message-ID: <20081016223637.GB31761@disturbed>
Mail-Followup-To: Jianjun Kong <jianjun@zeuux.org>,
	Tim Shimmin <tes@sgi.com>, stable@kernel.org,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <20081016002926.D912558FA22B@chook.melbourne.sgi.com> <20081016134112.GA8773@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016134112.GA8773@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 09:41:12PM +0800, Jianjun Kong wrote:
> 
> And the code above "return 0" can not be executed, so delete them.
> __________________________________________
> #if 0
>                         printk(KERN_INFO
>         "XFS: mount option \"%s\" not supported for remount\n", p);
>                         return -EINVAL;
> #else                                                                                                            
>                         return 0;
> -----------------------------------------

That ifdef was added to stub out the behaviour we *actually want*
remount to have when it encounters an invalid remount option.
The reason for leaving it is in the next release we should have all
the other problems we discovered by doing this fixed, so that
code will be re-enabled. Hence the temporary #if 0 around it.

So at this point, don't remove it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
