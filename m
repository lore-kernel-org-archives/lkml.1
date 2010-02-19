Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0BSPO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 10:14:26 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:60327 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0BSPOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 10:14:24 -0500
Date: Fri, 19 Feb 2010 09:14:00 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 34/35] x86: use num_processors for possible cpus
In-Reply-To: <4B7D9ABB.7020806@zytor.com>
Message-ID: <alpine.DEB.2.00.1002190912550.25964@router.home>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org> <1265793639-15071-35-git-send-email-yinghai@kernel.org> <4B7C98B9.1090903@zytor.com> <4B7CA825.9090309@kernel.org> <4B7D782F.20102@zytor.com> <alpine.DEB.2.00.1002181340380.7486@router.home>
 <4B7D9ABB.7020806@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010, H. Peter Anvin wrote:

> > As I have also repeatedly stated: Dynamic percpu data allocation when
> > onlining / offlining processors will complicate locking (cannot rely on
> > percpu be present anymore) and introduce numerous additional
> > hotplug notifiers into subsystems.
>
> I did state explicitly "on first up".  Trying to free it would be
> insane.  There are a couple of subsystems which are percpu memory
> pigs... so far it's not clear any of them actually matters in a
> production kernel.  60K * 16 phantom processors is still ~ 1 MB, which
> probably isn't enough to worry about but isn't great.

The first up still means the addition of notifiers for subsystems that
have to initialilze their per cpu data and dealing with potential races
that would be caused by adding those.

