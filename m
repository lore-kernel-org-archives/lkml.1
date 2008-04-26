Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYDZQZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYDZQZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYDZQZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:25:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbYDZQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:25:07 -0400
Date: Sat, 26 Apr 2008 17:24:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <chellwig@de.ibm.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] procfs task exe symlink
Message-ID: <20080426162458.GJ5882@ZenIV.linux.org.uk>
References: <1202348669.9062.271.camel@localhost.localdomain> <20080426091930.ffe4e6a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426091930.ffe4e6a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 09:19:30AM -0700, Andrew Morton wrote:

> +	set_mm_exe_file(bprm->mm, bprm->file);
> +
>  	/*
>  	 * Release all of the old mmap stuff
>  	 */
> 
> However I'd ask that you conform that this is OK.  If set_mm_exe_file() is
> independent of unshare_files() then we're OK.  If however there is some
> ordering dependency then we'll need to confirm that the present ordering of the
> unshare_files() and set_mm_exe_file() is correct.

No, that's fine (unshare_files() had to go up for a lot of reasons, one
of them being that it can fail and de_thread() called just above is
very much irreversible).
