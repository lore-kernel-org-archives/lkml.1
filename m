Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYEKQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYEKQ1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751438AbYEKQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:27:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:26327 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYEKQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=r4mrSyovEgYv4VFOuvfaBhyfwFL09NkibHCFoEEK34Ks3puJKyWnzc2ZwUs6kvrifwhO/Vx9vdM+GFWFv3yvd2vPWILaGnHF4yzQ5HxqqkpkiDZlFsZ+LqE3D+AEM7TnOYgSV+TKsjhpcpUdQCgSW81ZNDSFeq6e5NgUGIdh5Vc=
Date: Sun, 11 May 2008 21:22:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ricardo Martins <ricardo@scarybox.net>
Cc: julia@diku.dk, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH 1/4] sound/isa: use unsigned for loop index
Message-ID: <20080511172225.GA19791@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0805111450000.29620@ask.diku.dk> <20080511164335.GA19745@martell.zuzino.mipt.ru> <20080511160832.GA4709@macbookpro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511160832.GA4709@macbookpro>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:08:32PM +0100, Ricardo Martins wrote:
> On Sun, 11 May 2008 20:43, Alexey Dobriyan wrote:
> > On Sun, May 11, 2008 at 02:50:33PM +0200, Julia Lawall wrote:
> > > A few more cases in the spirit of the patch "Trivial: Replacement of always
> > > >0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scarybox.net>
> > 
> > And rationale for those would be ...?
> 
> Acccording to the kernel-janitors TODO [1], Jeff Garzik suggested the following:
> 
>   2) "unsigned int" is preferred to "int", it generates better asm code
>   on all platforms except sh5. This replacement needs to be done manually,
>   because often 'int' is required due to negative values -Exxx commonly
>   passed as error values.
> 
> Since (most) loop counters such as "int i" are always either zero or a positive
> number, they are perfect candidates for using unsigned int instead, imho.
> It goes without saying, that each case must be considered separately in
> case a negative value is indeed needed.
> 
> [1] http://kernelnewbies.org/KernelJanitors/Todo

So you've checked disassembly in both cases and saw it's better?

