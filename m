Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYJTNov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYJTNov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYJTNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:44:30 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39893 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYJTNo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:44:29 -0400
Date: Mon, 20 Oct 2008 09:42:11 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       hbabu@us.ibm.com, ebiederm@xmission.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] kexec: fix hang on i386 when panic occurs while
	console_sem is held
Message-ID: <20081020134211.GA15574@hmsreliant.think-freely.org>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020121339.GE10594@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:13:39PM +0200, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > Hey all-
> > 	Theres a corner case in 32 bit x86 kdump at the moment.  When 
> > the box panics via nmi, we call bust_spinlocks(1) to disable 
> > sensitivity to the console_sem (allowing us to print to the console in 
> > all cases), but we don't call crash_kexec, until after we call 
> > bust_spinlocks(0), which re-enables console_sem sensitivity.  The 
> > result is that, if we get an nmi while the console_sem is held and 
> > kdump is configured, and we try to print something to the console 
> > during kdump shutdown (which we often do) we deadlock the box.  The 
> > fix is to simply do what 64 bit die_nmi does which is to not call 
> > bust_spinlocks(0) until after we call crash_kexec.  Patch below tested 
> > successfully by me:
> 
> applied to tip/x86/urgent, thanks Neil!
> 
Thanks, Ingo!

> >  dumpstack_32.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> would be nice to unify this code some more - to create a new 
> arch/x86/kernel/dumpstack.c and fill it in with die_nmi() as a 
> beginning?
> 
Agreed, I'll try look into that as soon as I have some free time.

Regards
Neil

> 	Ingo
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
