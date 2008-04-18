Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbYDRPkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbYDRPkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbYDRPke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:40:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:54403 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbYDRPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=iKwCCNf7qIgVpEL+2Qg5I65wLbgScpKIgfHTJ3ZW0H2fHqNEJ8ISoFxI9s0rxZXqI26bV0qPPmuPEUjdK7kuICZQMnQy0J/OB/Jku1fxChJflemVGd/RwNoubzt4++0GaZtdMqSKEJodOZX0ZKqaJEvXanB9yoQCpgUlyyCEOgo=
Message-ID: <4808D1CC.80103@gmail.com>
Date: Fri, 18 Apr 2008 18:52:28 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       linux-man@vger.kernel.org
Subject: RLIMIT_RTTIME documentation for getrlimit.2
References: <20080208145950.GA3910@kernel.sg> <1202483445.6292.1.camel@lappy>	 <517f3f820802280712o3d756b4fq46461b226515e1f2@mail.gmail.com>	 <1204212100.12120.9.camel@twins>	 <cfd18e0f0804110156l658107e5x1f2695cacfc3ac75@mail.gmail.com>	 <1207904485.7074.28.camel@twins>	 <cfd18e0f0804110216l3c679bb6ned83f5d58d1c9d66@mail.gmail.com>	 <1207905668.7074.32.camel@twins>	 <cfd18e0f0804110227w37915734r8ca31271a3dfc8ab@mail.gmail.com>	 <1207906325.7153.2.camel@twins> <cfd18e0f0804110238l66fb60c8pa8ac934a2a43baa7@mail.gmail.com>
In-Reply-To: <cfd18e0f0804110238l66fb60c8pa8ac934a2a43baa7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Below is the draft text that I will add to the getrlimit.2 man page to describe
RLIMIT_RTTIME.  Does it look okay to you?  (I will add a pointer in
sched_setscheduler.2 to this description in getrlimit.2.)

       RLIMIT_RTTIME (Since Linux 2.6.25)
              Specifies a limit on the amount of CPU time that a
              process  scheduled  under  a  real-time scheduling
              policy may consume without making a blocking  sys-
              tem  call.   For  the  purpose of this limit, each
              time a process makes a blocking system  call,  the
              count  of  its consumed CPU time is reset to zero.
              The CPU time count is not  reset  if  the  process
              continues  trying to use the CPU but is preempted,
              its   time   slice   expires,    or    it    calls
              sched_yield(2).

              Upon  reaching the soft limit, the process is sent
              a SIGXCPU  signal.   If  the  process  catches  or
              ignores  this  signal  and continues consuming CPU
              time, then SIGXCPU will  be  generated  once  each
              second  until  the hard limit is reached, at which
              point the process is sent a SIGKILL signal.

              The intended use of this limit is to stop  a  run-
              away real-time process from locking up the system.

Cheers,

Michael

