Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbXAWFnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbXAWFnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbXAWFnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:43:21 -0500
Received: from 1wt.eu ([62.212.114.60]:2137 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbXAWFnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:43:20 -0500
Date: Tue, 23 Jan 2007 06:42:59 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@dannf.org>
Cc: Grant Coady <gcoady.lk@gmail.com>,
       Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Message-ID: <20070123054258.GA10301@1wt.eu>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <lpu7r2lbtpm5cui8v1qpuj2fb5k3vs6f4n@4ax.com> <20070122181942.GJ28073@colo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122181942.GJ28073@colo>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dann,

On Mon, Jan 22, 2007 at 11:19:43AM -0700, dann frazier wrote:
> On Mon, Jan 22, 2007 at 10:50:47AM +1100, Grant Coady wrote:
> > On Mon, 22 Jan 2007 00:03:21 +0100, Willy Tarreau <w@1wt.eu> wrote:
> > grant@sempro:/home/other$ uname -r
> > 2.4.34b
> > grant@sempro:/home/other$ mkdir test
> > grant@sempro:/home/other$ ln -s test testlink
> > ln: creating symbolic link `testlink' to `test': Operation not permitted
> > grant@sempro:/home/other$ echo "this is also a test" > test/file
> > grant@sempro:/home/other$ ln -s test/file test2
> > ln: creating symbolic link `test2' to `test/file': Operation not permitted
> > 
> > trying to create symlinks.
> > 
> > No problems creating symlinks with 2.4.33.3.
> 
> Yes, I've found that this varies depending upon the options passed. If
> uid=0, I can create symlinks, otherwise I always get permission
> denied. This behavior appears to be consistent with 2.6.
> 
> I also need to do some testing with the proposed patch to smbmount
> that will let you omit options (current versions will always pass an
> option to the kernel, even if you the user did not provide one).
> If you do not pass options, the behavior should fallback to
> server-provided values.
> 
> Note that this bug has been my only interaction with smbfs, so I'm
> certainly no expert on how it *should* behave. My plan is to
> take all of the use cases we're coming up with and try to maintain
> the "historic" 2.4 behavior as much as possible, but still not
> silently dropping user-provided mount options. When the behavior needs
> to change to honor them, I'll try to match what current 2.6
> does. Make sense?

Yes, it does for me. So to sum up, I apply your patch to 2.4.34.1
and it restores the same behaviour for Santiago and Grant as they get
in 2.6. Whether it's the expected behaviour or not is not the point,
as it will be easier for us to later mimic 2.6 if a change is needed
since we're not experts at all in this area.

If we're all OK for this, I'll go with that.

Thanks guys,
Willy

