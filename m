Return-Path: <linux-kernel-owner+w=401wt.eu-S1759627AbZEFMQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759627AbZEFMQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbZEFMQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:16:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47517 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZEFMQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:16:14 -0400
Date: Wed, 6 May 2009 14:15:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/7] kconfig: more featured minimum module configs
Message-ID: <20090506121502.GT25203@elte.hu>
References: <20090430185022.122124349@goodmis.org> <20090430191001.GA14108@elte.hu> <alpine.DEB.2.00.0904301854230.20374@gandalf.stny.rr.com> <20090501120100.GC24706@elte.hu> <alpine.DEB.2.00.0905011926330.20374@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905011926330.20374@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> 
> On Fri, 1 May 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > On Thu, 30 Apr 2009, Ingo Molnar wrote:
> > > 
> > > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > 
> > > > > This set of patches adds on top of my previous post.
> > > > > 
> > > > > It fixes CONFIG_IKCONFIG when CONFIG_IKCONFIG_PROC is not set.
> > > > >  (gcc optimizes the config out!)
> > > > > 
> > > > > As a request from Ingo, it now enables IKCONFIG and will also use 
> > > > > various locations to find a config to base against.
> > > > 
> > > > hm, now 'make localyesconfig' done on a Fedora distro kernel 
> > > > produces something very close to an allyesconfig:
> > > > 
> > > >  -rw-rw-r-- 1 mingo mingo 91930 2009-04-30 20:03 .config
> > > >  aldebaran:~/linux/linux> grep =y .config | wc -l
> > > >  3398
> > > > 
> > > > is that expected?
> > > 
> > > What config did it use? If it uses an allyesconfig that was 
> > > already made then it will not disable anything.
> > 
> > i used a regular config - then i also tried an allnoconfig - but no 
> > change in the result, bloated .config.
> 
> Could you send me the config it used (it should print out which 
> one it used) and the output of lsmod. Then I can test it locally.

'make allnoconfig' plus the module list i sent in a previous mail:

aldebaran:~/linux/linux> lsmod
Module                  Size  Used by
sunrpc                253904  1 
ipv6                  349568  50 
cpufreq_ondemand       73248  0 
acpi_cpufreq           75408  0 
freq_table             70400  2 cpufreq_ondemand,acpi_cpufreq
dm_multipath           82256  0 
i2c_i801               75932  0 
i2c_core               87192  1 i2c_i801
serio_raw              71556  0 
pcspkr                 68352  0 
pata_jmicron           69504  0 
iTCO_wdt               78208  0 
shpchp                 99160  0 
iTCO_vendor_support    68868  1 iTCO_wdt
igb                   144412  0 
dca                    71976  1 igb
pata_acpi              70528  0 
ata_generic            71428  0 

	Ingo
