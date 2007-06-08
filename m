Return-Path: <linux-kernel-owner+w=401wt.eu-S938580AbXFHKvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938580AbXFHKvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937387AbXFHKuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:50:55 -0400
Received: from www.osadl.org ([213.239.205.134]:37654 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937143AbXFHKuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:50:54 -0400
Subject: Re: [patch 03/54] NOHZ: Rate limit the local softirq pending
	warning output
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thaler <daniel@dthaler.de>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <466930D2.9010104@dthaler.de>
References: <20070608072127.352723000@sous-sol.org>
	 <20070608072147.763475000@sous-sol.org>  <466930D2.9010104@dthaler.de>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 12:50:44 +0200
Message-Id: <1181299844.4404.303.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 12:34 +0200, Daniel Thaler wrote:
> Chris Wright wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > ---------------------
> > 
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > The warning in the NOHZ code, which triggers when a CPU goes idle with
> > softirqs pending can fill up the logs quite quickly.  Rate limit the output
> > until we found the root cause of that problem.
> 
> Isn't the root cause found and fixed with "[patch 09/54] Prevent going
> idle with softirq pending"?

Yes, still we want the printk there to find places, which go into idle
with softirqs pending. There is at least one problem in the SLIP code,
which triggers this. OTOH we do not want those messages to flood the
syslog.

	tglx


