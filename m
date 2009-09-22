Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176AbZIVXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbZIVXTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZIVXTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:19:49 -0400
Received: from mail.vyatta.com ([76.74.103.46]:55594 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZIVXTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:19:48 -0400
Date: Tue, 22 Sep 2009 16:19:41 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>, Matt Helsley <matthltc@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make refrigerator cold
Message-ID: <20090922161941.519cf5da@s6510>
In-Reply-To: <200909230113.20461.rjw@sisk.pl>
References: <20090921210416.1982bcab@nehalam>
	<200909222154.09726.rjw@sisk.pl>
	<20090922140914.041b7328@s6510>
	<200909230113.20461.rjw@sisk.pl>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 01:13:20 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 22 September 2009, Stephen Hemminger wrote:
> > On Tue, 22 Sep 2009 21:54:09 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday 22 September 2009, Stephen Hemminger wrote:
> > > > By marking it cold, then the code path in kernel thread 
> > > > usage of try_to_freeze() that is normally used be
> > > > selected.
> > > 
> > 
> > In the code for try_to_freeze(), for optimization, it might
> > help to tell the compiler to not favor the code path where
> > the refigrator is being called.
> > 
> > Another way to do the same thing would be to do.
> >    if (unlikely(freezing(current))) {
> > 	refrigerator();
> > 	return 1;
> >    } else
> > 	return 0;
> > 
> > or build unlikely into the freezing function (see need_resched).
> > 
> > I saw this by trying to minimize the number of intstructions
> > in pktgen which is a special case.
> 
> OK, thanks.
> 
> Will it be fine with you if I add the patch to the suspend-2.6 tree with the
> above information in the changelog?
> 
> Rafael

Sure, any of the possibilities works, you choose.
