Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZKICKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZKICKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbZKICKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:10:09 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:21729 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZKICKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qxrPxYA9r99mUwTrKJAkijIUFB+NcxqW8ADhfuwAcRBxktPuizBRB+I7TiagPL9MYQ
         wv7C2xo6XBmWm3i0q2fa77tzy7B0gnntplgcwQkE3JcyqGFMTFiHhjNZFjx7neivOJFz
         2YqPVXmxs1qQHpjY5vMw6eAz0eoXX6QfZGLZk=
Date: Mon, 9 Nov 2009 03:10:12 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Subject: Re: [PATCH -v6 01/13] tracing: convert trace_clock_local() as weak
	function
Message-ID: <20091109021009.GB13153@nowhere>
References: <cover.1256569489.git.wuzhangjin@gmail.com> <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <747deea2f18d5ccffe842df95a9dd1c86251a958.1256569489.git.wuzhangjin@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 11:13:18PM +0800, Wu Zhangjin wrote:
> trace_clock_local() is based on the arch-specific sched_clock(), in X86,
> it is tsc(64bit) based, which can give very high precision(about 1ns
> with 1GHz). but in MIPS, the sched_clock() is jiffies based, which can
> give only 10ms precison with 1000 HZ. which is not enough for tracing,
> especially for Real Time system.
> 
> so, we need to implement a MIPS specific sched_clock() to get higher
> precision. There is a tsc like clock counter register in MIPS, whose
> frequency is half of the processor, so, if the cpu frequency is 800MHz,
> the time precision reaches 2.5ns, which is very good for tracing, even
> for Real Time system.
> 
> but 'Cause it is only 32bit long, which will rollover quickly, so, such
> a sched_clock() will bring with extra load, which is not good for the
> whole system. so, we only need to implement a arch-specific
> trace_clock_local() for tracing. as a preparation, we convert it as a
> weak function.
> 
> The MIPS specific trace_clock_local() is coming in the next two patches.
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>


Yep, if trace_clock_local() had to be a strict alias
to sched_clock(), we would have simply used sched_clock().

If an arch need to implement it another way, then yeah making
it weak is a good thing.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

