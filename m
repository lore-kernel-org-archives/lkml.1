Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXDMUhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXDMUhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030190AbXDMUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:37:13 -0400
Received: from gw.goop.org ([64.81.55.164]:60437 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030187AbXDMUhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:37:11 -0400
Message-ID: <461FE9D1.1000803@goop.org>
Date: Fri, 13 Apr 2007 13:36:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org> <461FE8EC.3090304@zytor.com>
In-Reply-To: <461FE8EC.3090304@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> I suggest, for clarity and to minimize bloat:

I think it would save a page, at most.  But OK.  (Also, if you're
running !PAE, these pages will actually become part of the init_mm
pagetable, so there's no memory wastage at all.)

> #ifdef CONFIG_X86_PAE
> # define PAGE_TABLE_SIZE    ((2048+4)*4096)
> #else
> # define PAGE_TABLE_SIZE    ((1024+1)*4096)

1024 should be enough; the pgd is still swapper_pg_dir, and there are no
pmds.

    J
