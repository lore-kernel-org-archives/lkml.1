Return-Path: <linux-kernel-owner+w=401wt.eu-S935079AbZLPScn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935079AbZLPScn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762784AbZLPScm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:32:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34420 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbZLPScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:32:41 -0500
Subject: Re: perf and libdwarf on debian
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091216135448.GD11618@aftab>
References: <20091216135448.GD11618@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 19:32:20 +0100
Message-ID: <1260988340.21028.198.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 14:54 +0100, Borislav Petkov wrote:
> Hi,
> 
> even after installing libdwarf-dev on my debian box here, make in tools/perf/
> still complains that it cannot find libdwarf:
> 
> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231
> 
> The problem is that the include path on debian is not
> /usr/include/libdwarf/ but simply /usr/include because the debian
> package libdwarf-dev puts the headers straight into /usr/include.
> 
> Now, fixing this in the build system could get ugly and too much (see
> below), IMHO, so how about adding a README file in <tools/perf/>
> which explains that on Debian-like systems, one should mkdir
> /usr/include/libdwarf/ and symlink libdwarf.h and dwarf.h into it?
> 
> There could be a better solution though...?

Yeah, like file a bug with RH for placing them in such an utterly stupid
location.

Also, I'd not bother with testing debian, just do

#include <dwarf.h>

and simply add -I/usr/include/libdwarf to CPPFLAGS or something like
that.

Then again, its not like debian would ever ship something recent enough
to actually build perf with, even my karmic machine comes with
libdwarf-20080409 which to me reads like ancient and not befitting a
distro released a month or so ago.



