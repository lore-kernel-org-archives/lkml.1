Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbXGTMMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbXGTMMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXGTMLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:11:51 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44377 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753594AbXGTMLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:11:50 -0400
Message-ID: <384933499.09699@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 20 Jul 2007 20:11:43 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] compacting file_ra_state
Message-ID: <20070720121143.GA8584@mail.ustc.edu.cn>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@osdl.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20070720100740.106917381@mail.ustc.edu.cn> <384926279.42287@ustc.edu.cn> <p73y7hbux4d.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73y7hbux4d.fsf@bingen.suse.de>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:34:42PM +0200, Andi Kleen wrote:
> Fengguang Wu <wfg@mail.ustc.edu.cn> writes:
> 
> > Use 'unsigned int' instead of 'unsigned long' for the readahead indexes/sizes.
> > 
> > This helps reduce memory consumption on 64bit CPU when
> > a lot of files are opened.
> > 
> > Note that the (smaller) 32bit index can support up to 16PB file.
                                                          ~~~~
                                                sorry, it's 16TB ;)

> > Which should be sufficient large at least for now.
> 
> This would add a new limit to 64bit architectures.  Surely keeping
> start at pgoff_t will not be a big issue? The other fields can be
> 32bit.

Yeah, it counts for about 4MB memory for 1M opened files.

But, the filp size is now 296 on x86_64, so slab-objects-per-page = 13.
Adding another 4bytes, it remains in 13;
Taking 4bytes more, it increases to 14.
So pgoff_t consumes no more memory actually.

