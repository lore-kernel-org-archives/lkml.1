Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0BUVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:09:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:51473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0BUVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:09:57 -0500
Date: Sun, 21 Feb 2010 13:11:44 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: What's the right value for idle= (was: Re: [linux-pm]
 regression on P-II SMP)
Message-ID: <20100221131144.34a9b8e1@infradead.org>
In-Reply-To: <201002212136.03783.rjw@sisk.pl>
References: <Pine.LNX.4.64.1002212117540.9624@axis700.grange>
	<201002212136.03783.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010 21:36:03 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 21 February 2010, Guennadi Liakhovetski wrote:
> > Hi
> > 
> > my 2xP-II@400MHz locks up with 2.6.32(.X) unless I specify "idle=*"
> > on the kernel command-line, where "*" is one of "poll," "mwait,"
> > "halt," and only "nomwait" indeed locks it up. Last kernel known to
> > work was 2.6.25. So, it doesn't bother me all that much - I have a
> > way to boot it, but maybe someone would be interested to fix this
> > (this system already has a few quirks on the kernel command line,
> > so, one more doesn't really hurt;)). What interests me more - which
> > of those shall I be using? From Documentation/kernel-parameters.txt
> > it looks like "mwait" should be best for me? Or should I be using
> > "halt?" "Poll" does indeed fry CPUs - raises sys temperatures to
> > 50 / 60 degrees C. Power-saving is not that much of a concern for
> > me - I only run that system occasionally, but it shouldn't produce
> > more heat than it must;) And since this system does have a broken
> > ACPI (Compaq AP400), I wouldn't try to be too smart with it.
> 
> I guess "mwait" is the right one, but let's try to ask experts.

can you get us /proc/cpuinfo ?
(only one of the cpus, the other ones are just duplicates)

if the CPU advertizes mwait, we normally ought to use it,
but there's some exceptions to that due to buggy-as-**** bioses.

can you also run powertop -d and get that output ?
(preferably on a fully known working kernel)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
