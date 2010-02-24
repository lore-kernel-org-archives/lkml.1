Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0BXTdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:33:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:56301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab0BXTdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:33:23 -0500
Message-ID: <4B857F00.10005@suse.com>
Date: Wed, 24 Feb 2010 14:33:20 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-1.5 Thunderbird/3.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: fix ftrace_event_call alignment for use with
 gcc 4.5
References: <4B85770B.6010901@suse.com>
In-Reply-To: <4B85770B.6010901@suse.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2010 01:59 PM, Jeff Mahoney wrote:
>  GCC 4.5 introduces behavior that forces the alignment of structures to
>  use the largest possible value. The default value is 32 bytes, so if
>  some structures are defined with a 4-byte alignment and others aren't
>  declared with an alignment constraint at all - it will align at 32-bytes.
> 
>  For things like the ftrace events, this results in a non-standard array.
>  When initializing the ftrace subsystem, we traverse the _ftrace_events
>  section and call the initialization callback for each event. When the
>  structures are misaligned, we could be treating another part of the
>  structure (or the zeroed out space between them) as a function pointer.
> 
>  This patch forces the alignment for all the ftrace_event_call structures
>  to 4 bytes.
> 
>  Without this patch, the kernel fails to boot very early when built with
>  gcc 4.5.
> 
>  It's trivial to check the alignment of the members of the array, so it
>  might be worthwhile to add something to the build system to do that
>  automatically. Unfortunately, that only covers this case. I've asked one
>  of the gcc developers about adding a warning when this condition is seen.

BTW, the analysis for this is available here:

https://bugzilla.novell.com/show_bug.cgi?id=582222

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuFfwAACgkQLPWxlyuTD7KvZgCgluUzuO91K0wARk0SaLJeCV7x
we0AnAjPT/M1c4wD0Ti6mUjsZjKx5CXX
=zJLJ
-----END PGP SIGNATURE-----
