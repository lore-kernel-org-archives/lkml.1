Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXCPV4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXCPV4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXCPV4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:56:32 -0400
Received: from gw.goop.org ([64.81.55.164]:53098 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965966AbXCPV4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:56:31 -0400
Message-ID: <45FB1288.5080909@goop.org>
Date: Fri, 16 Mar 2007 14:56:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [patch 17/26] Xen-paravirt_ops: Add nosegneg capability to the
 vsyscall page notes
References: <20070316212655.B6C6B1801C5@magilla.sf.frob.com>
In-Reply-To: <20070316212655.B6C6B1801C5@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> This should be:
>
> NOTE_KERNELCAP_BEGIN(1, 1)
> NOTE_KERNELCAP(0, "nosegneg")
> NOTE_KERNELCAP_END
>
> i.e. 1->0 in the "bit" member.  (Note the ld.so.conf.d file must have the
> matching bit number for ldconfig-based lookups to do the right thing.)
> Or else:
>
> NOTE_KERNELCAP_BEGIN(1, 2)
> NOTE_KERNELCAP(0, "nosegneg")
> NOTE_KERNELCAP_END
>
> i.e. 1->2 in the "mask" member.  (The mask value should be 1<<bit.)
>   

Thanks Roland.  I've never really understood this stuff, and I just
copied this cargo-cultishly.

I'm not quite sure what you're suggesting here though.  Do you mean one of:

NOTE_KERNELCAP_BEGIN(1, 1)
NOTE_KERNELCAP(0, "nosegneg")
NOTE_KERNELCAP_END

or

NOTE_KERNELCAP_BEGIN(1, 2)
NOTE_KERNELCAP(1, "nosegneg")
NOTE_KERNELCAP_END

is the correct thing to use?

> Some pre-release glibc's (before 2.4) had a bug in the code that parses
> this, and would crash parsing the correct note.  Using the wrong bit value
> with nonmatching mask worked around this.  IIRC, no glibc release ever
> included the buggy version of the code.  In nonbuggy glibc, the mismatched
> value causes the "nosegneg" to be omitted from the directory search (under
> LD_LIBRARY_PATH and default directories), though ldconfig-based lookups
> will work (the most common case).
>   

Are you saying that one of the corrected forms might cause old glibcs to
crash, or just ignore nosegneg?

    J

