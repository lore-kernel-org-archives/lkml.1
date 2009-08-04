Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbZHDNfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbZHDNfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbZHDNfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:35:30 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:49993 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754305AbZHDNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:35:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEEAHrUd0pMQWXi/2dsb2JhbACBUtMlhBgFgUo
Date: Tue, 4 Aug 2009 09:35:15 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: ltt-dev@lists.casi.polymtl.ca, Matt Fleming <matt@console-pimps.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org
Subject: sh: Add ftrace syscall tracing support (was: Re: [ltt-dev] [PATCH]
	sh: added LTT_DUMP_TABLES support)
Message-ID: <20090804133515.GB23807@Krystal>
References: <1249040606-15402-1-git-send-email-peppe.cavallaro@st.com> <20090731155048.GD8847@Krystal> <4A77F585.2070508@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A77F585.2070508@st.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:25:34 up 157 days,  9:51,  3 users,  load average: 0.62, 1.03,
	1.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Giuseppe CAVALLARO (peppe.cavallaro@st.com) wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi Mathieu,
> 
> Mathieu Desnoyers wrote:
> > So now we only need to fix entry-common.S to get everything working.
> 
> I've just noticed that this has been already done:
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Flethal%2Fsh-2.6.git;a=commitdiff_plain;h=c652d780c9cf7f860141de232b37160fe013feca;hp=c1340c053be7a43d837a3acb352d5008be865a55
> I think it will be necessary to to re-add the _TIF_KERNEL_TRACE against
> this modifications, only.
> 

Hrm, I don't like the approach taken there. It extends the bitmasks for
_TIF_WORK_SYSCALL_MASK and _TIF_ALLWORK_MASK beyond 8 bits, and adds a &
0xff in the assembly whenever needed. This begs for a bug to be
introduced.

If we need something like that on SH, we should probably declare a 8-bit
only bitmask for those assembly sites which does not need the
FTRACE_SYSCALL thread flag, and another mask for sites which need to
test the 2 bytes.

I would also consider other instructions than 2 consecutive "tst" to
extend test with a 2 bytes mask. Something like loading an integer in a
register and testing with the register rather than doing 2 immediate
value tests.

Mathieu


> Regards,
> Peppe
> 
> > 
> > Mathieu
> > 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iEYEARECAAYFAkp39YMACgkQ2Xo3j31MSSJWmQCeJfvmg3cUHsGGy5QNdRcOJbO9
> C1AAnR6gAuKZhaRt4+4UWiWDGucgD2DJ
> =9cBd
> -----END PGP SIGNATURE-----
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
