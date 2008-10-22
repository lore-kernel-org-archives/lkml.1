Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYJVKSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYJVKSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYJVKSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:18:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40857 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbYJVKSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:18:43 -0400
Message-Id: <1224670721.25843.1280616145@webmail.messagingengine.com>
X-Sasl-Enc: /PQN4AHufBMjU2oHk4CyokETilJXm37KF7XvtcadXpAJ 1224670721
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Neil Horman" <nhorman@tuxdriver.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081017210013.GD23591@hmsreliant.think-freely.org>
 <20081020121339.GE10594@elte.hu>
 <20081020134211.GA15574@hmsreliant.think-freely.org>
 <20081020150731.GA25999@mailshack.com>
 <20081020150834.GA26018@mailshack.com>
 <20081021144505.GA25750@hmsreliant.think-freely.org>
Subject: Re: [PATCH] x86: make oops_begin and oops_end equal
In-Reply-To: <20081021144505.GA25750@hmsreliant.think-freely.org>
Date: Wed, 22 Oct 2008 12:18:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 10:45:05 -0400, "Neil Horman"
<nhorman@tuxdriver.com> said:
> On Mon, Oct 20, 2008 at 05:08:34PM +0200, Alexander van Heukelum wrote:
> > Mostly use the x86_64 version of oops_begin() and oops_end() on
> > i386 too. Changes to the original x86_64 version:
> > 
> Hey, doing a sight review this am here.  Didn't find anything major, but
> I did
> find a few little nits.  comments inlie

Hi Neil,

Thanks for the review. I've sent a redone patch series just a moment
ago, based on your comments. There was also another problem with these
two patches: oops_end(flags, regs, signr) had special behaviour for
regs=NULL that I did not consider before. The series has grown due
to this issue...

>> [...]
> Hmm.  I think this creates the same case that I just fixed in my initial
> post. If we start using oops_end with this here, it may be possible to call
> crash_kexec with the console_sem held.  If that happens, we deadlock.  I
> think you should be able to move this clause up above the bust_spinlocks(0)
> without any issue, and that would take care of that

Indeed. The new series does exactly that.

>> [...]
> This undoes my previous patch.  I realize your second patch fixes it
> properly so the ordering is correct when oops_begin and oops_end are used, but if you
> could rediff so this isn't here, I'd appreciate it.  If these patches are
> committed separately, you'll avoid having the tree in a state where that deadlock
> can reoccur (even if it is just for one commit)

Yeah, I quickly rediffed the patches I already had. The new series
leaves
it as is until die_nmi is replaced by the oops_begin/oops_end version.

>> [...]
> If you're going to add the crash_kexec here (which looking at the call
> sites, makes sense to me), you should likely remove it from the critical section
> of die and die_nmi, just to avoid the redundancy.  Same issue as the 32 bit
> version above applies, this needs to happen before you call bust_spinlocks(0).

Indeed.

> Fix those issues, and the rest looks good to me.

I think I've done that ;).

Thanks,
Greetings,
    Alexander

(I will probably not be able to respond to e-mail until after the
weekend)
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

