Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab0CIG2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0CIG2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:28:45 -0500
Date: Tue, 9 Mar 2010 08:28:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Avi Kivity <avi@redhat.com>, john cooper <john.cooper@third-harmonic.com>,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, mtosatti@redhat.com,
       zamsden@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100309062803.GI16909@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BB6FA.1000505@oss.ntt.co.jp>
 <20100301125223.GI16909@redhat.com>
 <4B8BBE61.3020503@oss.ntt.co.jp>
 <20100301132609.GJ16909@redhat.com>
 <4B8C11DC.1060004@third-harmonic.com>
 <20100302072809.GS16909@redhat.com>
 <4B936B27.1050207@redhat.com>
 <m1aauipfwq.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aauipfwq.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 03:11:49PM -0800, Eric W. Biederman wrote:
> Avi Kivity <avi@redhat.com> writes:
> 
> > On 03/02/2010 09:28 AM, Gleb Natapov wrote:
> >> On Mon, Mar 01, 2010 at 02:13:32PM -0500, john cooper wrote:
> >>    
> >>> Gleb Natapov wrote:
> >>>
> >>>      
> >>>> Think about what happens if in the middle of
> >>>> instruction emulation some data from device emulated in userspace is
> >>>> needed. Emulator should be able to tell KVM that exit to userspace is
> >>>> needed and restart instruction emulation when data is available.
> >>>>        
> >>> setjmp/longjmp are useful constructs in general but
> >>> IME are better suited for infrequent exceptions vs.
> >>> routine usage.
> >>>      
> >> Exception condition during instruction emulation _is_
> >> infrequent.
> >
> > Well, with mmio you'd expect it to happen every read access.
> 
> Of course if you are hitting that kind of case very often
> you don't want to do the emulation in the kernel but
> in userspace so you don't have to take the context switch
> overhead and everything else.
> 
The devices that do mmio most often are already in the kernel
to avoid exit to usesrapce on each access. And mmio may be the
most frequent cause of emulation, but not the only one.

> I know running emulations in userspace was for dosemu
> the difference between a 16 color ega emulation on X
> that was unusable to one that was good enough to play video
> games like wolfenstein and doom.
> 
> Eric

--
			Gleb.
