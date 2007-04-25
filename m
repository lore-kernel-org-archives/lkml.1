Return-Path: <linux-kernel-owner+w=401wt.eu-S1423293AbXDYIYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423293AbXDYIYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423285AbXDYIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:24:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53218 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423291AbXDYIYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:24:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	<20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com>
	<20070424093253.GA1075@erig.dyndns.org>
	<20070425001428.GA1366@kroah.com> <20070425002958.GR3468@stusta.de>
	<20070425005111.GA22673@kroah.com> <20070425012153.GT3468@stusta.de>
Date: Wed, 25 Apr 2007 02:19:09 -0600
In-Reply-To: <20070425012153.GT3468@stusta.de> (Adrian Bunk's message of "Wed,
	25 Apr 2007 03:21:53 +0200")
Message-ID: <m11wi8uarm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> On Tue, Apr 24, 2007 at 05:51:11PM -0700, Greg KH wrote:
>> On Wed, Apr 25, 2007 at 02:29:58AM +0200, Adrian Bunk wrote:
>> > On Tue, Apr 24, 2007 at 05:14:28PM -0700, Greg KH wrote:
>> > > On Tue, Apr 24, 2007 at 11:32:53AM +0200, Wolfgang Erig wrote:
>> > > > On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
>> > > > > On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
>> > > > > > This email lists some known regressions in Linus' tree compared to
> 2.6.20.
>> > > > > > 
>> > > > > > If you find your name in the Cc header, you are either submitter of
> one
>> > > > > > of the bugs, maintainer of an affectected subsystem or driver, a
> patch
>> > > > > > of you caused a breakage or I'm considering you in any other way
>> > > > > > possibly involved with one or more of these issues.
>> > > > > > 
>> > > > > > Due to the huge amount of recipients, please trim the Cc when
> answering.
>> > > > > > 
>> > > > > > 
>> > > > > > Subject    : gammu no longer works
>> > > > > > References : http://lkml.org/lkml/2007/4/20/84
>> > > > > > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
>> > > > > > Status     : unknown
>> > > > > 
>> > > > > I've asked for more information about this, and so far am not sure
> it's
>> > > > > a real problem.
>> > > > 
>> > > > It is a real problem for me.
>> > > > I tried this on 2 different boxes with the same behaviour.
>> > > > No sync between my Nokia mobile and Linux with the latest kernel :(
>> > > 
>> > > Sorry, I didn't see your response, have followed up on lkml now.
>> > 
>> > It turned out this was actually a bug in Gammu that will be fixed in 
>> > the next release of Gammu.
>> 
>> Ah, ok, thanks for letting me know.
>> 
>> But how was the kernel version change triggering it?
>
> I don't know, perhaps a side effect of Eric's work in kernel/signal.c?

Perhaps there has been a bit of churn.  Most of what I have done has
been fixing corner cases like not sending a signal to the wrong task,
after our original target has exited.

Although in conjunction with Oleg and some others there has been things
like changing locking to rcu or making locks more local so the timing
may have changed.  Which is make some subtle timing thing my best
guess.  For timing changes just about anything could have triggered
something.

I took a quick glance at the code and I certainly touched some of
the helpers like send_sigio that seem to be called by fasync
processing but I haven't a clue what FASYNC really does.  So I'm
having trouble putting this all into perspective.

I guess it's possible I fixed something without realizing it.


Eric
