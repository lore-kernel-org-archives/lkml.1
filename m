Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbYCEVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbYCEVzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbYCEVzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:55:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38350 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763783AbYCEVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:55:09 -0500
Date: Wed, 5 Mar 2008 22:56:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
Message-ID: <20080305215630.GA15653@one.firstfloor.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <4911.1204701694@turing-police.cc.vt.edu> <p738x0x5al2.fsf@bingen.suse.de> <25220.1204747197@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25220.1204747197@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:59:57PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 05 Mar 2008 18:45:13 +0100, Andi Kleen said:
> > Valdis.Kletnieks@vt.edu writes:
> > >
> > > So we're in the same 4K as the VDSO64_* values, but some 0x4fe past the
> > > gtod_data.  Anybody got a hint as to what the heck it was doing?
> > 
> > Try this patch:
> > 
> > Remove unlikelies in vsyscall path
> 
> Nope, sorry... same behavior.  Apparently it's a (un)likely someplace
> else...
> 
> I'm trying to figure out what's at 0x9be into the vdso, but not having
> a lot of luck.

You can do objdump -Sr on the vdso/vsyscall object files and see
if there are any external references to unlikely related functions. If yes
the problem is in that function

-Andi
