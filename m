Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXERDmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXERDmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXERDmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:42:06 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:38703 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbXERDmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RmVFSL1zSjMRYT4C11B6T5GsfQ/cggDKbynRTxUJ4z44SFnUTrufMVenflNMjPXQ4laCOQE3uMyv5FMn1Pia/J0sqQLH67GONk4WO5JH4254L1FdBaTy8mOyisOAPEWBqTBeY/mgtdCYOYwVD5vLDzqmTeIVKx6YjQi5xAZIL/c=
Message-ID: <a781481a0705172041q6bc87f04v7a60eb62ad26d6@mail.gmail.com>
Date: Fri, 18 May 2007 09:11:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Benjamin LaHaise" <bcrl@kvack.org>
Subject: Re: Asynchronous scsi scanning
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Christoph Hellwig" <hch@infradead.org>,
       "Simon Arlott" <simon@fire.lp0.eu>,
       "James Bottomley" <james.bottomley@steeleye.com>,
       "Dave Jones" <davej@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org,
       "Robert P. J. Day" <rpjday@mindspring.com>
In-Reply-To: <20070517194326.GC30571@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
	 <20070517172023.GL10562@parisc-linux.org>
	 <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
	 <20070517182414.GA12170@infradead.org>
	 <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
	 <20070517185115.GA13207@infradead.org>
	 <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
	 <20070517193953.GM10562@parisc-linux.org>
	 <20070517194326.GC30571@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, May 17, 2007 at 01:39:54PM -0600, Matthew Wilcox wrote:
> > On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
> > > Hmmm, actually those other users could easily write and maintain
> > > a 20-line patch that does the wait for async scans thing for them
> > > using /proc/scsi/scsi in any case.
> >
> > How about the three users who're bothered by this extra module being
> > built maintain a one-line patch to Kconfig and leave well enough alone?

So you expect users bothered with this to actually get on lkml / write to it
and complain about this? And because not everybody else who is
disgusted with this user-invisible-default-m-module-way-of-solving-this-problem
(when it shouldn't be a module at all) is doing that, it's just "the three"?

It is *shocking* / funny how you *still* want to defend that:

static int __init wait_scan_init(void)
{
	scsi_complete_async_scans();
	return 0;
/* BTW this could've been return scsi_complete_async_scans();
 * I see scsi_complete_async_scans() never fails, but still. */
}
late_initcall(wait_scan_init);

deserves/must be a separate module, and that doing:

config SCSI_WAIT_SCAN
	tristate
	default m

is the best way to solve this !!!

In any case, firstly, I'm not a user of SCSI at all. I'm still
interested in this,
but because for me (like I've said twice already) this is simply a (trivial,
perhaps) matter of doing something in the kernel in a better/proper way,
than what is being done currently.

It's also somewhat a matter of *taste* (and hence subjective), if you
_still_ don't get it, Matthew, then there's no point continuing this thread
and trying to convince you ad infinitum.

On 5/18/07, Benjamin LaHaise <bcrl@kvack.org> wrote:
> The module has an added bonus that it doesn't require any new tools to
> make work.  Doing it via sysfs/procfs means a new rev of whatever tool
> generates the boot initrd, plus fixing up boot scripts.  Loading a module
> can be done via a simple option to the existing boot tools.

I do not expect the alternative ways to change this that we've discussed
so far to necessitate any major "fixing up", but yeah a minor touch-up
would clearly be required.
