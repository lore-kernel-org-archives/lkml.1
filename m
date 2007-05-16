Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbXEPXxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbXEPXxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbXEPXxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:53:37 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56393
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXEPXxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:53:36 -0400
From: Rob Landley <rob@landley.net>
To: "Francesco Pretto" <ceztko@gmail.com>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Date: Wed, 16 May 2007 19:52:52 -0400
User-Agent: KMail/1.9.1
Cc: Stephen.Clark@seclark.us, "Dave Jones" <davej@redhat.com>,
       "Tejun Heo" <htejun@gmail.com>, "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no> <464AFD61.10209@seclark.us> <e5ab0f710705160649s5a8a0ef8s8ba7f4be76bc873c@mail.gmail.com>
In-Reply-To: <e5ab0f710705160649s5a8a0ef8s8ba7f4be76bc873c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705161952.53200.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 9:49 am, Francesco Pretto wrote:
> 2007/5/16, Stephen Clark <Stephen.Clark@seclark.us>:
> > >On Tuesday 15 May 2007 5:08 pm, Dave Jones wrote:
> > >
> > >I'm confused.  Could someone please explain?
> > >
> > I agree. This didn't happen when I was just using the ide driver, why
> > can't libata work as well
> > as the old ide driver.
> >
> 
> Read my reply to that post. To summarize: libata, prior to 2.6.22rc1,
> lacked the feature to spindown the hard disk. The last discussion was
> about who's responsable to issue the STANDBYNOW command to the hard
> disk. Response from the discussion is: the kernel. Trying to issue it
> form userspace (iff your shutdown(8) implementation do so) will now
> result in a big fat warning, until these compatibility measures will
> be dropped from the kernel (soon or later).

The last bit was what threw me.  It seemed that the kernel was changed to do 
the right thing, but only as a compatability measure that would be dropped 
because userspace should be changed to start doing it (which seemed crazy).

It seems that the _warning_ is the compatability measure that will be dropped 
(or perhaps the ability for userspace to do the wrong thing at all?), and the 
kernel will continue to DTRT.

It's a bit confusing for those of us coming in late in the discussion. :)

Rob
