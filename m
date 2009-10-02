Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZJBQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZJBQDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbZJBQDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:03:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:42064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751657AbZJBQDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:03:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19GLqh7Yr1GRtfMRegtqCrBvv8AC5YVERactp3Nyz
	Iox365saeCbsJv
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
In-Reply-To: <20091002154020.GC4494@redhat.com>
References: <200910021255.27689.czoccolo@gmail.com>
	 <20091002124921.GA4494@redhat.com>
	 <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com>
	 <1254497520.10392.11.camel@marge.simson.net>
	 <20091002154020.GC4494@redhat.com>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 18:03:29 +0200
Message-Id: <1254499409.20436.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 11:40 -0400, Vivek Goyal wrote:
> On Fri, Oct 02, 2009 at 05:32:00PM +0200, Mike Galbraith wrote:
> > On Fri, 2009-10-02 at 17:27 +0200, Corrado Zoccolo wrote:
> > > On Fri, Oct 2, 2009 at 2:49 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > On Fri, Oct 02, 2009 at 12:55:25PM +0200, Corrado Zoccolo wrote:
> > > >
> > > > Actually I am not touching this code. Looking at the V10, I have not
> > > > changed anything here in idling code.
> > > 
> > > I based my analisys on the original patch:
> > > http://lkml.indiana.edu/hypermail/linux/kernel/0907.1/01793.html
> > > 
> > > Mike, can you confirm which version of the fairness patch did you use
> > > in your tests?
> > 
> > That would be this one-liner.
> > 
> 
> Ok. Thanks. Sorry, I got confused and thought that you are using "io
> controller patches" with fairness=1.
> 
> In that case, Corrado's suggestion of refining it further and disabling idling
> for seeky process only on non-rotational media (SSD and hardware RAID), makes
> sense to me.

One thing that might help with that is to have new tasks start out life
meeting the seeky criteria.  If there's anything going on, they will be.

	-Mike

