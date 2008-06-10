Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYFJQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYFJQ1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYFJQ1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:27:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYFJQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:27:08 -0400
Date: Tue, 10 Jun 2008 09:24:50 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
Message-ID: <20080610162450.GB13538@kroah.com>
References: <20080610160408.GB11685@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610160408.GB11685@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 07:04:08PM +0300, Adrian Bunk wrote:
> James Bottomley recently discovered that we have 
> {request,release}_firmware() dummies for the case of the actual 
> functions not being available and has a fix for the bug that was 
> actually causing build errors for built-in users with 
> CONFIG_FW_LOADER=m.
> 
> But now missing selects on FW_LOADER are no longer visible at 
> compile-time at all and can become runtime problems.
> 
> FW_LOADER is infrastructure with relatively small codesize we can 
> safely enable for everyone, and only for people who really need small 
> kernels (and can be expected to know what they are doing) it matters 
> being able to disable it.
> 
> This patch therefore always sets FW_LOADER=y and allows users only to 
> disable it with EMBEDDED=y.
> 
> As a bonus, we can then get rid of all "select FW_LOADER" plus the due 
> to it required "depends on HOTPLUG" which removes some complexity from 
> our Kconfig files.

Well, we can't get rid of that if EMBEDDED is set, right?

You sent this as an RFC before, I thought people said to just fix up all
of the dependancies with drivers that needed FW_LOADER to be enabled,
that would be easier, right?

thanks,

greg k-h
