Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbZJSWuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbZJSWuC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:50:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbZJSWuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:50:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:34208 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZJSWuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:50:00 -0400
Date: Tue, 20 Oct 2009 00:50:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
In-Reply-To: <94a0d4530910190949y265426cbq4c32466a9fab8966@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0910200047200.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>  <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>  <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de>  <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com> 
 <alpine.LSU.2.00.0910191655220.8582@wotan.suse.de>  <94a0d4530910190815n4cf2c2ebmd288f6e7501b1ba5@mail.gmail.com>  <alpine.LSU.2.00.0910191716580.8582@wotan.suse.de> <94a0d4530910190949y265426cbq4c32466a9fab8966@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> > This statement of your makes me wonder why you have submitted the patch in
> > the first place, as you are apparently not sure whether adding
> > uninitialized_var() is a valid thing to do or not.
[ ... ]
> In any case, if the patch is not correct, then somebody should point
> that out, which is what the patch review process is for. Alternatively
> I could have sent an email asking what is happening here, but from my
> point of view this patch serves exactly the same purpose, and has the
> advantage that it might turn out to be correct.
>
> It's not as if I didn't do any homework while writing this patch.

Sorry if it sounded to offensive, I have probably been a little bit too 
tired ysterday.

> > The gcc warning in this case is actually bogus, as msqid64 is touched only
> > iff cmd == IPC_SET, and in such case, copy_msqid_from_user() initializes
> > it properly.
> 
> Yes, but it's used by ipcctl_pre_down, which from what I can see is
> only using those arguments when cmd == IPC_SET, so everything is ok.
> But still, I don't think the compiler _should_ know what
> ipcctl_pre_down is going to do, if you look _only_ at msgctl_down,
> then uninitialized_var is OK.

Well at least older compilers were able to see this, only 4.4 seems to be 
warning here ... I have applied the patch for now, but I am really not 
fully convinced about it yet, we should probably report it to gcc folks 
anyway.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
