Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbYD3LC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbYD3LC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 07:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757233AbYD3LCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 07:02:47 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56835 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbYD3LCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 07:02:47 -0400
Subject: Re: [PATCH] procfs task exe symlink
From: Matt Helsley <matthltc@us.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <chellwig@de.ibm.com>,
       Hugh Dickins <hugh@veritas.com>
In-Reply-To: <20080426162458.GJ5882@ZenIV.linux.org.uk>
References: <1202348669.9062.271.camel@localhost.localdomain>
	 <20080426091930.ffe4e6a8.akpm@linux-foundation.org>
	 <20080426162458.GJ5882@ZenIV.linux.org.uk>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Apr 2008 04:02:38 -0700
Message-Id: <1209553358.29759.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-04-26 at 17:24 +0100, Al Viro wrote:
> On Sat, Apr 26, 2008 at 09:19:30AM -0700, Andrew Morton wrote:
> 
> > +	set_mm_exe_file(bprm->mm, bprm->file);
> > +
> >  	/*
> >  	 * Release all of the old mmap stuff
> >  	 */
> > 
> > However I'd ask that you conform that this is OK.  If set_mm_exe_file() is
> > independent of unshare_files() then we're OK.  If however there is some
> > ordering dependency then we'll need to confirm that the present ordering of the
> > unshare_files() and set_mm_exe_file() is correct.
> 
> No, that's fine (unshare_files() had to go up for a lot of reasons, one
> of them being that it can fail and de_thread() called just above is
> very much irreversible).

They are independent. It just needs to be called before exec_mmap() --
so your fix looks good.

Cheers,
	-Matt Helsley

