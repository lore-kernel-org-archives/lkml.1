Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYL1Szo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYL1Szo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYL1Sze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 13:55:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbYL1Szd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 13:55:33 -0500
Date: Sun, 28 Dec 2008 20:08:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
Message-ID: <20081228190840.GD496@one.firstfloor.org>
References: <1230238726-17506-1-git-send-email-avi@redhat.com> <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49578896.8030703@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 04:09:26PM +0200, Avi Kivity wrote:
> I don't see how syscall could work on i386, and indeed:

i386 has task gates which support unconditional stack switching. But there 
are no 64bit task gates, just ISTs.

BTW I think there are more similar problems in your patch too.

> 
> >vdso32.so-$(VDSO32-y)        += int80
> >vdso32.so-$(CONFIG_COMPAT)    += syscall
> >vdso32.so-$(VDSO32-y)        += sysenter
> 
> It's disabled.  Is that the reason?

No.  All interesting 32bit CPUs have SYSENTER; the only one who has SYSCALL 
but no SYSENTER is the K6, but it has a weird early variant of SYSCALL with
more problems which was never worth supporting.

-Andi
-- 
ak@linux.intel.com
