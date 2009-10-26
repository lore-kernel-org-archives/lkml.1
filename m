Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZJZRft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZJZRft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 13:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZJZRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 13:35:48 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:39773 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZJZRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 13:35:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=XfiFLDWD5k/6PeKeJZBGq649GcUthkDvCdB3UUTz4fM3NNwsgyesL+S6f3vM3vIZRH
         2tD36jQcAGvXBcC9YeGpJnFDff5CI1k9ZcWSJY/4Hg/stdk72fRiU9kGvt6tVFYA5KMS
         s3C4EM/u9u1/JrR1S/o1nwk2k7Qt8OQYgO2sI=
Subject: Re: [PATCH -v6 07/13] tracing: add dynamic function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <1256575500.26028.323.camel@gandalf.stny.rr.com>
References: <cover.1256569489.git.wuzhangjin@gmail.com>
	 <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
	 <3f47087b70a965fd679b17a59521671296457df1.1256569489.git.wuzhangjin@gmail.com>
	 <f290e125634d164ec65b09b24b269815f78455ab.1256569489.git.wuzhangjin@gmail.com>
	 <07dc907ec62353b1aca99b2850d3b2e4b734189a.1256569489.git.wuzhangjin@gmail.com>
	 <374da7039d2e1b97083edd8bcd7811356884d427.1256569489.git.wuzhangjin@gmail.com>
	 <3c82af564d70be05b92687949ed134ce034bf8db.1256569489.git.wuzhangjin@gmail.com>
	 <a11775df0ec9665fab5861f4fa63a3e192b9ffec.1256569489.git.wuzhangjin@gmail.com>
	 <1256573175.26028.310.camel@gandalf.stny.rr.com>
	 <1256574910.5642.228.camel@falcon>
	 <1256575500.26028.323.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 27 Oct 2009 01:35:40 +0800
Message-Id: <1256578540.5642.283.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:45 -0400, Steven Rostedt wrote:
> On Tue, 2009-10-27 at 00:35 +0800, Wu Zhangjin wrote:
> 
> > If remove the long jump, we at least to change the $mcount_regex in
> > scripts/recordmcount.pl, the addr + 12 in arch/mips/include/asm/ftrace.h
> > and the _mcount & ftrace_caller in mcount.S and the ftrace_make_nop &
> > ftrace_make_call in arch/mips/kernel/ftrace.c back to the -v4 version.
> > 
> > I think this method of supporting module is not that BAD, no obvious
> > overhead added except the "lui...addiu..." and two more "nop"
> > instructions. and it's very understandable, so, just use this version?
> 
> You don't nop the lui and addiu do you? If you do you will crash the
> machine.

Not test it yet, Seems what you have mentioned in another thread:

b  1f
....
1:

is a good idea, it will only left one "lui" and one "b 1f" instruction
there.

(I'm sleepy now, the time is Tue Oct 27 01:34:51 CST 2009 in China, See
you~~)

Regards,
	Wu Zhangjin

