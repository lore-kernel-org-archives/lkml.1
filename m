Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbXCVQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbXCVQ1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934109AbXCVQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:27:00 -0400
Received: from saeurebad.de ([85.214.36.134]:43994 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108AbXCVQ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:26:59 -0400
Date: Thu, 22 Mar 2007 17:26:04 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: roland <devzero@web.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - fix compile warning: `found' might be used uninitialized in this function
Message-ID: <20070322162550.GB5591@localhost>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	roland <devzero@web.de>, linux-kernel@vger.kernel.org
References: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc> <20070321235607.GA10998@localhost> <20070322004540.45d8ee87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322004540.45d8ee87.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 22, 2007 at 12:45:40AM -0800, Andrew Morton wrote:
> > On Thu, Mar 22, 2007 at 12:48:05AM +0100, roland wrote:
> > > fs/block_dev.c: In function `bd_claim_by_kobject':
> > > fs/block_dev.c:953: warning: `found' might be used uninitialized in this 
> > > function
> > 
> > found actually _is_ used uninitialized if the call to bd_claim() returns
> > anything but 0.
> 
> No, it isn't.
> 
>         if (res || found)
>                 free_bd_holder(bo);
> 
> `found' won't be evaluated if res!=0.

Oh, thank you very much. So this warning is another gcc false-positive?

> The code in there is irksome - it'd be nice to find some way of
> restructuring it to make it less obscure, and to kill that warning.

Functionscope or filescope? ;)

=Hannes
