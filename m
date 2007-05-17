Return-Path: <linux-kernel-owner+w=401wt.eu-S1757385AbXEQOk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbXEQOk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXEQOkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:40:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:22854 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXEQOks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DNZxGzzGp6h3AxO4ZXpyO8UDo3wwEPLiWK+h9gvcSefPhfI9PXgYIVDKgjkAT8TGUqCavYRNpRMyOsrXmayV3NWMj6r9uc+AFUGkXt1gIbWklytiF14Du4akzh126BAz42/Bc2SlBns87va0ybS4CQ58vxR9beTAOFGYBvVRf+U=
Date: Thu, 17 May 2007 18:39:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: TITAN - check for allocated memory
Message-ID: <20070517143927.GC8991@cvg>
References: <20070516181332.GB16348@cvg> <20070516194101.GK4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516194101.GK4095@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Al Viro - Wed, May 16, 2007 at 08:41:01PM +0100]
| On Wed, May 16, 2007 at 10:13:32PM +0400, Cyrill Gorcunov wrote:
| > This patch adds checking for allocated memory
| > which is used to hold AGP info. Also some whitespace
| > cleanup.
| 
| Could you please not do that again?  Whitespace cleanup is nice as a separate
| followup, but as it is it just obscures the real changes in patch.  Digging
| out
| 
| > @@ -767,6 +767,11 @@ titan_agp_info(void)
| >  	 * Allocate the info structure.
| >  	 */
| >  	agp = kmalloc(sizeof(*agp), GFP_KERNEL);
| > +	if (agp == NULL) {
| > +		printk(KERN_ERR "TITAN - cannot allocate struct of size %d bytes\n",
| > +		       sizeof(*agp));
| > +		return NULL;
| > +	}
| 
| out of hundreds of lines in patch just makes review harder.  Incidentally,
| %d is not size_t, it's int.  Use %zu, please.
| 

I really sorry about this. Thanks for note.

		Cyrill

