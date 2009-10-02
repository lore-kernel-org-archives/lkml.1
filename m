Return-Path: <linux-kernel-owner+w=401wt.eu-S1756332AbZJBP0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbZJBP0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 11:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZJBP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 11:26:05 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:58220 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbZJBP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 11:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=RSi8fzQ+vh4yR4cDE4+LKmnXuIKGqSvItCcld9JyixWUXglk6ccB8Qm8lQYLmr4niM
         ONU6/DOnLoPJzRjHGCCQPdWOokPjH5cxLjSrsrv1RDVkG3FYoImGJKGDVnTMCvVIiUHj
         NTyNT0RZaQDrZE7ffAZ1W0BW74OgBTSui2+Is=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Fri, 2 Oct 2009 17:26:06 +0200
Message-ID: <7c86c4470910020826h5668ac3al233fe3a181545952@mail.gmail.com>
Subject: libpfm4 source code available
From: stephane eranian <eranian@googlemail.com>
To: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am happy to announce that the source code for the brand new version
of libpfm, libpfm4,  is now available.

Libpfm4 is a helper library which can be used by tools programming
PMU other performance events on Linux and other operating systems.

The core service translates an event name into an event encoding. The
encoding depends on the event, underlying hardware, and may also depend
on the OS API. At its core, the library ignores any OS API. It provides a set
of entry points to  list and encode events.

The library also provides API-specific calls to setup parameters to performance
API syscalls. In the initial release, for instance, it provides a
dedicated call to
prepare the structure needed by the perf_events API. The library does not
invoke the OS API.

Events are specified as strings. Unit masks and filters can be passed as well.
For instance, on Intel Core, one can say:

           pfm_get_perf_event_attr("RS_UOPS_DISPATCHED:u:i:c=1", &attr);

Where:
  u : monitors at the user level only
  i  : inverts the meaning counter-mask (from >= to <)
  c : counter-mask, i.e., the number of cycles in which n or more occurrences
      of the event are observed

Unit masks (sub-events) and filters depend on each event.

This version of the library is NOT backward compatible with libpfm3 and does
NOT yet provide support for perfmon2.x.

The library supports the following PMU models:
   - all Intel X86 processors, including Intel Nehalem uncore PMU
   - AMD64 processors from K7 to Fam11h

Warning: there is support for more processors than what is currently supported
              by perf_events, e.g., Intel Nehalem uncore PMU, Intel Core Duo.

Support for other processors (as offered by libpfm3) will be added gradually but
will depend on the OS API providing access as well.

Furthermore, the library provides access to perf_events generic software and
hardware events and also trace points.

The library comes with a set of generic examples demonstrating the listing and
generic encoding services. But it also comes with a bunch of simple perf_event
examples showing common monitoring scenarios.

The library comes with man pages for each entry point. The man pages are also
available on the perfmon2 web site:

     htp://perfmon2.sf.net

To get the source code, you need to use GIT. You can clone the repository with:

     git clone git://perfmon2.git.sourceforge.net/gitroot/perfmon2/libpfm4


Thanks.
