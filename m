Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYBEWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYBEWEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYBEWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:04:13 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38904 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759086AbYBEWEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:04:12 -0500
Date: Tue, 5 Feb 2008 23:04:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205220431.GC1630@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205160214.GD24331@elf.ucw.cz> <20080205160913.GB28812@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205160913.GB28812@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 17:09:13, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > > From: Jiri Kosina <jkosina@suse.cz>
> > > 
> > > brk: check the lower bound properly
> > > 
> > > There is a check in sys_brk(), that tries to make sure that we do not 
> > > underflow the area that is dedicated to brk heap.
> > > 
> > > The check is however wrong, as it assumes that brk area starts immediately 
> > > after the end of the code (+bss), which is wrong for example in 
> > > environments with randomized brk start. The proper way is to check whether 
> > > the address is not below the start_brk address.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > 
> > ACK.
> 
> actually, does the patch above from Jiri solve the problem with your 11 
> year old binaries too? (Sorry if it has been mentioned elsewhere, i 
> could not decode it from this thread.)

No, it should just make the problem more obvious...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
