Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXLRWwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXLRWwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXLRWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:52:10 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42332 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbXLRWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:52:09 -0500
Date: Tue, 18 Dec 2007 17:51:30 -0500
Message-Id: <200712182251.lBIMpUbp030364@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] tmpfs: allow filepage alongside swappage 
In-reply-to: Your message of "Tue, 18 Dec 2007 22:01:24 GMT."
             <Pine.LNX.4.64.0712182200230.27165@blonde.wat.veritas.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0712182200230.27165@blonde.wat.veritas.com>, Hugh Dickins writes:

>  redirty:
>  	set_page_dirty(page);
> -	return AOP_WRITEPAGE_ACTIVATE;	/* Return with the page locked */
> +	if (wbc->for_reclaim)
> +		return AOP_WRITEPAGE_ACTIVATE;	/* Return with page locked */
> +	unlock_page(page);
> +	return 0;

Just curious, but didn't you (or someone else) mention that they wanted to
do away with AOP_WRITEPAGE_ACTIVATE entirely?  If these patches are for
2.6.25, would that be the right time?

Erez.
