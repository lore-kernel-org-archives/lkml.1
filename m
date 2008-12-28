Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYL1UV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYL1UV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 15:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYL1UVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 15:21:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56188 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYL1UVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 15:21:16 -0500
Date: Sun, 28 Dec 2008 21:34:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
Message-ID: <20081228203425.GF496@one.firstfloor.org>
References: <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com> <20081228190840.GD496@one.firstfloor.org> <4957CE78.6030706@redhat.com> <4957D14B.60805@redhat.com> <4957DCC3.3060505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4957DCC3.3060505@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 10:08:35PM +0200, Avi Kivity wrote:
> Avi Kivity wrote:
> >Avi Kivity wrote:
> >>1. Add per-cpu IDT
> >
> >Or we could have just two IDTs - one with IST and one without.  I 
> >clocked LIDT at 58 cycles (and we need two per heavyweight switch), so 
> >it's not that wonderful.
> 
> This makes the whole thing unworthwhile.  The vmload/vmsave pair costs 
> only 200 cycles (I should have started with this), and 120 cycles on the 
> heavyweight path plus complexity are not worth 200 cycles on the 
> lightweight path.

Actually to switch ISTs you need to change the TSS, not the IDT.
But I suppose that won't be any faster.

-Andi
-- 
ak@linux.intel.com
