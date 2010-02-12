Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab0BLFV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 00:21:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:58415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0BLFVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:21:55 -0500
Date: Thu, 11 Feb 2010 21:23:13 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: thomas@archlinux.org, Wojciech Ploskonka <wploskonka@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alex Chiang <achiang@hp.com>,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit 69d258
 (fwd)
Message-ID: <20100211212313.59c0e12b@infradead.org>
In-Reply-To: <alpine.LNX.2.00.1002111929300.1668@localhost.localdomain>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
	<20100108171513.GB22713@ldl.fc.hp.com>
	<20100109134352.3dedd4ea@infradead.org>
	<alpine.LNX.2.00.1001100155370.1325@localhost.localdomain>
	<20100109160836.26a344a9@infradead.org>
	<alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
	<20100109164240.43b21247@infradead.org>
	<alpine.LNX.2.00.1001100251210.1334@localhost.localdomain>
	<20100112160734.89ee6b11.akpm@linux-foundation.org>
	<20100112213205.7d74808a@infradead.org>
	<alpine.LNX.2.00.1002102245200.1675@localhost.localdomain>
	<20100210205637.63131c24@infradead.org>
	<alpine.LNX.2.00.1002111929300.1668@localhost.localdomain>
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

On Thu, 11 Feb 2010 20:00:47 +0200 (EET)
Dimitrios Apostolou <jimis@gmx.net> wrote:

> On Wed, 10 Feb 2010, Arjan van de Ven wrote:
> > On Wed, 10 Feb 2010 22:51:38 +0200 (EET)
> > Dimitrios Apostolou <jimis@gmx.net> wrote:
> >>
> >> As I understand, in his case the C3 state is unstable and exits
> >> immediately. I have asked him to post the dmidecode output so you
> >> can put him on the exception list too. However I now believe that
> >> more and more users will be facing the same problem, it's not
> >> something you find easily, especially on desktop machines! What do
> >> you think?
> >
> > if C3 does not work, this needs to be fixed in the code that
> > implements C3, not in the code that selects C3.
> >
> >
> > Modern systems should have working C3; if one does not it needs to
> > be investigated as to why it's not working. One cause could be a
> > PME that we're not handling (I've seen that a few times in our
> > lab), lspci -vvv will show that.
> >
> > But regardless, it's not the task of the code that selects a C
> > state to deal with....
> 
> Wojo (CC'd) can you run as root lspci -vvv and attach the output, so
> the experts can have a look?
> 
> Arjan, in this case a bisection was not performed but the symptoms
> are exactly the same as mine:
> * powertop showing thousands of interrups but showing no specific
> process causing them
> * The situation is caused only when the "processor" module is
> inserted and after a message about "marking TSC as unstable due to
> halts in idle", exactly like my case
> 
> Hmmm actually a difference is that in my case the system used the
> acpi_pm clocksource, but in Wojo's case it used hpet.
> 
> If I understand correctly what you said, this is a bug in another
> piece of code, and I assume that the previous behaviour of the
> governor was hiding it, avoiding C3 state completely, right?
> 
> 

the old governor would not avoid c3, each time it would try it a bunch
of times and eventually fall back... not very good, but mostly
invisible to you.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
