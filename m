Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYKFQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYKFQC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:02:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbYKFQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:02:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbYKFQCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:02:46 -0500
Date: Thu, 6 Nov 2008 11:01:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081106160154.GA7461@redhat.com>
References: <20081106153022.215696930@redhat.com> <1225986593.7803.4688.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225986593.7803.4688.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:49:53PM +0100, Peter Zijlstra wrote:
> On Thu, 2008-11-06 at 10:30 -0500, vgoyal@redhat.com wrote:
> > Hi,
> > 
> > If you are not already tired of so many io controller implementations, here
> > is another one.
> > 
> > This is a very eary very crude implementation to get early feedback to see
> > if this approach makes any sense or not.
> > 
> > This controller is a proportional weight IO controller primarily
> > based on/inspired by dm-ioband. One of the things I personally found little
> > odd about dm-ioband was need of a dm-ioband device for every device we want
> > to control.  I thought that probably we can make this control per request
> > queue and get rid of device mapper driver. This should make configuration
> > aspect easy.
> > 
> > I have picked up quite some amount of code from dm-ioband especially for
> > biocgroup implementation.
> > 
> > I have done very basic testing and that is running 2-3 dd commands in different
> > cgroups on x86_64. Wanted to throw out the code early to get some feedback.
> > 
> > More details about the design and how to are in documentation patch.
> > 
> > Your comments are welcome.
> 
> please include
> 
> QUILT_REFRESH_ARGS="--diffstat --strip-trailing-whitespace"
> 
> in your environment or .quiltrc
> 

Sure, I will do. First time user of quilt. :-)

> I would expect all those bio* files to be placed in block/ not mm/
> 

Thinking more about it, probably block/ will be more appropriate place.
I will do that.

> Does this still require I use dm, or does it also work on regular block
> devices? Patch 4/4 isn't quite clear on this.

No. You don't have to use dm. It will simply work on regular devices. We
shall have to put few lines of code for it to work on devices which don't
make use of standard __make_request() function and provide their own
make_request function. 

Hence for example, I have put that few lines of code so that it can work
with dm device. I shall have to do something similar for md too.

Though, I am not very sure why do I need to do IO control on higher level
devices. Will it be sufficient if we just control only bottom most
physical block devices?

Anyway, this approach should work at any level.

Thanks
Vivek
