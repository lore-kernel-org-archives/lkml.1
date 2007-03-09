Return-Path: <linux-kernel-owner+w=401wt.eu-S2992861AbXCIBe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992861AbXCIBe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992865AbXCIBe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:34:26 -0500
Received: from kanga.kvack.org ([66.96.29.28]:48577 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992861AbXCIBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:34:25 -0500
Date: Thu, 8 Mar 2007 20:34:05 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
Message-ID: <20070309013405.GI6209@kvack.org>
References: <f2b55d220703081508r3d8d033cu99f53104943d16cb@mail.gmail.com> <45F09F9C.4030801@cosmosbay.com> <f2b55d220703081557k8101e68g1a3556e42f68416@mail.gmail.com> <45F0A71C.2000800@cosmosbay.com> <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220703081645vc78905cj56afbc58ad2113d8@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I think it would make the kernel (negligibly) faster to bump
> f_pos before the vfs_write() call.  Unless fget_light sets fput_needed
> or the write doesn't complete cleanly, you won't have to touch the
> file table entry again after vfs_write() returns.  You can adjust

Any number of things can cause a short write to occur, and rewinding the 
file position after the fact is just as bad.  A sane app has to either 
serialise the writes itself or use a thread safe API like pwrite().

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
