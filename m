Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYHLUGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYHLUGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYHLUGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:06:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbYHLUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:06:14 -0400
Date: Tue, 12 Aug 2008 13:05:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <87proe81c1.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, OGAWA Hirofumi wrote:
> 
> However, there are some similar stuff: ->st_size, ->st_nlink and
> ->st_ino in stat() (cp_old_stat()). Maybe EOVERFLOW is the reason for
> consistency...

.. I actually had an old binary that triggered that case (actually, it was 
O_LARGEFILE in open()), and didn't work as a result. I only needed to run 
it once, so I literally hacked up a once-time-use kernel that just removed 
the EOVERFLOW in open.

So no, I'm not a fan of EOVERFLOW at all. Not in readdir(), not really 
anywhere else. 

		Linus
