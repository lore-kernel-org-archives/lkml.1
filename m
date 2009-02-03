Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZBCNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZBCNdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZBCNdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:33:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbZBCNdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:33:05 -0500
Date: Tue, 3 Feb 2009 14:32:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090203133251.GD29046@elte.hu>
References: <497F69A4.2070007@intel.com> <20090130202219.GA1253@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130202219.GA1253@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> On Tue 2009-01-27 12:08:04, Kok, Auke wrote:
> > 
> > This tracer monitors regular file open() syscalls. This is a fast
> > and low-overhead alternative to strace, and does not allow or
> > require to be attached to every process.
> > 
> > The tracer only logs succesfull calls, as those are the only ones we
> > are currently interested in, and we can determine the absolute path
> > of these files as we log.
> 
> Maybe fanotify() should be used instead?
> 
> Or maybe just plain strace? One slow boot should not really hurt...

ptrace is out of question for good tracing because it's not a transparent 
probe. (ptrace monopolizes the traced task - if we use that then we break 
regular strace usage.)

	Ingo
