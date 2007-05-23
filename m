Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbXEWAN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbXEWAN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXEWANS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:13:18 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34780 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757739AbXEWANR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:13:17 -0400
Date: Tue, 22 May 2007 17:12:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: section mismatches
Message-ID: <20070523001247.GA3390@sequoia.sous-sol.org>
References: <20070522145245.727813f3.akpm@linux-foundation.org> <46537996.20302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46537996.20302@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Andrew Morton wrote:
> > WARNING: vmlinux(.text+0xc02fe884): Section mismatch: reference to .init.text: (between 'iret_exc' and '_etext')
> > WARNING: vmlinux(.data+0xc0439099): Section mismatch: reference to .init.text:xen_start_kernel (between 'startup_xen' and 'boot_gdt_descr')
> >   
> 
> This is safe, but I'll clean it up.  I'll also have a look at iret_exc,
> some of which might be Xen-related.  Actually, iret_exc is in the fixup
> section, but it gets used from several places, so it might be worth just
> making it .text.

I tracked down a bunch of these a little while back.  It's not really
iret_exc, but since there is no _sfixup/_efixup markers iret_exc is the
closest symbol to pick on.  All the [iret_exc, _etext] warnings I found
were completely harmless from things that used, for example, mfn_to_pfn
in an __init function (which sucks in a fixup via __get_user).
