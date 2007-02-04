Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbXBDUVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbXBDUVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 15:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbXBDUVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 15:21:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbXBDUVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 15:21:00 -0500
Date: Sun, 4 Feb 2007 15:20:53 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Message-ID: <20070204202053.GC20307@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local> <45C362D2.2040407@tmr.com> <1170516376.3073.1015.camel@laptopd505.fenrus.org> <45C63E30.4010106@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C63E30.4010106@tmr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 04, 2007 at 03:12:32PM -0500, Bill Davidsen wrote:
> Arjan van de Ven wrote:
> >>Because user threading can avoid context switches, there will always be 
> >>cases where it will outperform o/s threads for hardware reasons.
> >
> >actually.. switching from one "real" thread to another in Linux is not
> >an actual context switch in the hardware sense... at least this part of
> >your argument seems to be incorrect ;)
> >
> How does that work? Switching between kernel threads requires going into 
> the kernel, user level thread switches are all done in user mode.
> 
> Do you have some way to change o/s threads w/o going into the kernel?

But going into kernel is not very expensive on Linux.

On the other side, the overhead you need to add for every single syscall
that might block for the M:N threads and the associated complications
which make it far harder to conform to POSIX IMHO far outweight the costs
of going into the kernel for a context switch.

	Jakub
