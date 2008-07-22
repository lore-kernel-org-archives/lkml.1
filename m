Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbYGVMym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbYGVMym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGVMyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:54:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:38171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYGVMye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:54:34 -0400
Date: Tue, 22 Jul 2008 05:54:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080722055421.2023d261@infradead.org>
In-Reply-To: <488589E6.5070300@keyaccess.nl>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	<488589E6.5070300@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 09:19:02 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 22-07-08 05:02, David Woodhouse wrote:
> 
> > Many users of timers don't really care too much about exactly when
> > their timer fires -- and waking a CPU to satisfy such a timer is a
> > waste of power. This patch implements a 'range' timer which will
> > fire at a 'convenient' moment within given constraints.
> > 
> > It's implemented by a deferrable timer at the beginning of the
> > range, which will run some time later when the CPU happens to be
> > awake. And a non-deferrable timer at the hard deadline, to ensure
> > it really does happen by then.
> 
> Are there actually users for this (not just in theory)? The
> deferrable timer sort of sounds like all I'd ever want if I, as you
> say, wouldn't really care...

there's a few; mostly around hardware timeout..For example Stephen want
it for his drivers.

EXT3 journal flushing is another one where we can easily say 
"between 4 and 7 seconds" rather than "exactly at 5"


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
