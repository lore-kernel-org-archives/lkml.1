Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbYCJXP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbYCJXP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbYCJXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:14:51 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:33326 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766AbYCJXOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:14:49 -0400
From: Stephan Diestelhorst <langer_mann@web.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Tue, 11 Mar 2008 00:14:39 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
References: <200803051559.09962.langer_mann@web.de> <87iqzu8r2q.fsf@basil.nowhere.org> <200803102226.39044.langer_mann@web.de>
In-Reply-To: <200803102226.39044.langer_mann@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110014.40246.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX18BclyNJYWPcO+wGsAb8yCVmcCl1Qy7ytdQC0kh
	yX3sH4gpoXv9QuGBA74qvpkpuIcVq9/9Ne3K96j5cvbYUP/4o5
	2xgtHd/xg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Diestelhorst wrote:
> Andi Kleen wrote:
> > Stephan Diestelhorst <langer_mann@web.de> writes:
> > > 
> > > New attempt with full clobbers, note that I deliberatly did not change
> > > the order of the output registers. Real output operands still preceede
> > > outputs used for potential clobbering.
> > > 
> > > I'm not too sure about the EBP push/pop frame, but as folks pointed
> > > out already, we should not trust the SMI code too much.
> > 
> > Be careful -- older gcc versions tend to abort for inline asm
> > that clobbers too many registers. Especially when the register
> > is already used (like ebp in a frame pointer enabled kernel) 
> 
> > Make sure it at least works on the oldest supported gcc version 
> > (gcc 3.2) and with frame pointer on.
> 
> As I've said, I do not expect this to be problematic, but will test,
> just to be sure! 

I've tried it on the following GCCs: 3.3, 3.4, 4.0, 4.1, all with and
without frame-pointer ommission.
Result: As expected. Worked w/o problems, warnings anything.

Apologies for not testing gcc-3.2, but compiling it from source did
not work with libtool complaining about tags in libmath. I'd be
grateful if someone with working gcc-3.2 could try this out.

Cheers,
  Stephan
