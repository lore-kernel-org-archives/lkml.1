Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbXJBGmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbXJBGmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbXJBGlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:41:53 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31251 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbXJBGlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:41:52 -0400
Date: Tue, 2 Oct 2007 10:40:55 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Uninline fork.c/exit.c
Message-ID: <20071002064055.GA6144@localhost.sw.ru>
References: <20071001121553.GA6153@localhost.sw.ru> <20071001110814.4e137e03@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001110814.4e137e03@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:08:14AM -0700, Arjan van de Ven wrote:
> On Mon, 1 Oct 2007 16:15:53 +0400
> Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > Save ~650 bytes here.
> > 
> > add/remove: 4/0 grow/shrink: 0/7 up/down: 430/-1088 (-658)
> > function                                     old     new   delta
> > __copy_fs_struct                               -     202    +202
> > __put_fs_struct                                -     112    +112
> > __exit_fs                                      -      58     +58
> > __exit_files                                   -      58     +58
> > exit_files                                    58       2     -56
> > put_fs_struct                                112       5    -107
> > exit_fs                                      161       2    -159
> > sys_unshare                                  774     590    -184
> > copy_process                                4031    3840    -191
> > do_exit                                     1791    1597    -194
> > copy_fs_struct                               202       5    -197
> > 
> > No difference in lmbench lat_proc tests on 2-way Opteron 246.
> > Smaaaal degradation on UP P4 (within errors).
> > 
> 
> is there any impact on stack usage?

No differences in checkstack output which threshold is 100 bytes.

