Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYJ1Xyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYJ1Xyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYJ1Xyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:54:33 -0400
Received: from mail.crca.org.au ([67.207.131.56]:47412 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYJ1Xyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:54:32 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for
	frozen	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1KuyFq-0006Sc-PC@pomaz-ex.szeredi.hu>
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop> <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu>
	 <1225235054.9661.37.camel@nigel-laptop>
	 <E1Kuxk4-0006NT-Ie@pomaz-ex.szeredi.hu>
	 <1225235860.9661.42.camel@nigel-laptop>
	 <E1KuxvH-0006Q0-Dy@pomaz-ex.szeredi.hu>
	 <1225237298.9661.55.camel@nigel-laptop>
	 <E1KuyFq-0006Sc-PC@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 29 Oct 2008 10:54:29 +1100
Message-Id: <1225238069.9661.61.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos.

On Wed, 2008-10-29 at 00:45 +0100, Miklos Szeredi wrote:
> On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Wed, 2008-10-29 at 00:24 +0100, Miklos Szeredi wrote:
> > > On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > > Remember, though, that we're only freezing fuse at the moment, and
> > > > strictly one filesystem at a time. We can thus happily wait for the
> > > > i_mutex taken by some other process to be released.
> > > 
> > > Not going to work: you need to wait for all requests to be finished,
> > > but those might depend on some other fuse filesystem which has already
> > > been frozen.
> > 
> > Okay. In that case, am I right in thinking that the request waiting on
> > the frozen filesystem will be stuck in request_wait_answer,
> 
> Yes.
> 
> > and the
> > userspace process that was trying to satisfy the request will be stuck
> > in the FUSE_MIGHT_FREEZE call that was invoked for the frozen
> > filesystem?
> 
> No, it already passed that, before the filesystem got frozen.  But it
> doesn't matter, in either case i_mutex will already have been taken by
> the VFS and it won't be released until the request completely
> finishes.

I think we're making different assumptions. I'm assuming that one of
those solutions we already discussed is implemented, such that we don't
start freezing a new filesystem until all the requests for the current
filesystem are dealt with. Perhaps I should come up with a new version
of the patch that implements that.

Nigel

