Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbZAYMC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbZAYMC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 07:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbZAYMCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 07:02:45 -0500
Received: from mail-ew0-f10.google.com ([209.85.219.10]:52475 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZAYMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 07:02:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SqeP1VpMrSqSfGScaECbA5EcA+ohcKD5VXzHJFCKaYlUuL0OhRFEDxQFIbPRnwc02d
         Xh6BryeJyoApo7EOhgmwkLUIK9zxOgATnI3h0RLd5iievXJKXFBfN5s7bJ0ZGdyfgiSZ
         F/RRaSRn/LkFejQiRtJw7GnN6dkZiOfHd52fE=
Date: Sun, 25 Jan 2009 15:08:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Migration of kernel interfaces to seq_files breaks pread()
	consumers
Message-ID: <20090125120818.GA4454@x200.localdomain>
References: <Pine.LNX.4.64.0901162229420.12858@kitami.corp.google.com> <20090124181924.d633523c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090124181924.d633523c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 06:19:24PM -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 23:51:35 -0800 (PST) Paul Turner <pjt@google.com> wrote:
> 
> > 
> > (Specifically) Several interfaces under /proc have been migrated to use 
> > seq_files.  This was previously observed to be a problem with VMware's 
> > reading of /proc/uptime.  We're now running into the same problem on  
> > /proc/<pid>/stat; we have many consumers performing preads on this 
> > interface which break under new kernels.
> > 
> > Reverting these migrations presents other problems and doesn't scale with 
> > everyones' pet dependencies over an abi that's been
> > broken :(
> 
> We changed userspace-visible behaviour and broke real applications. 
> This is a serious matter.  So serious in fact that your report has
> languished without reply for a week.
> 
> Reverting those changes until we have a suitable reimplementation which
> doesn't bust userspace is 100% justifiable.
> 
> In which kernel versions is this regression present?
> 
> What would a revert look like?  Big and ugly or small and simple?  Do
> the original commits (which were they?) still revert OK?

This is bug http://bugzilla.kernel.org/show_bug.cgi?id=11856
Some of us think what to do here.

Original patch not revertable as is.
