Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbYEAVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbYEAVh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760479AbYEAVhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:37:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:60390 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEAVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cs4lYGh6s7krGm8an0AQRDkYgK6UFhM0e8VCU0NfZBDW+j29JHNNHHVy0RtHKxPmOQo2KSph3FXVFZC43MMmp8/p19EWnmwttbNuYuk61ip1DBsl8VrbvL4IpF91SL8gIi+Cr74CHvayKGshgpF1HGOQhPx+LTlg01AlJ768Xz0=
Date: Fri, 2 May 2008 02:32:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
Message-ID: <20080501223228.GA17060@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com> <20080501141919.78b7dc4f.akpm@linux-foundation.org> <1209677160.12461.267.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209677160.12461.267.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:26:00PM -0700, Daniel Walker wrote:
> 
> On Thu, 2008-05-01 at 14:19 -0700, Andrew Morton wrote:
> > On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Some files in the net/9p directory uses "int" for flags. This can
> > > cause hard to find bugs on some architectures. This patch converts the
> > > flags to use "long" instead.
> > 
> > gargh.
> > 
> > > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > > where checks are done to ensure all flags are of size sizeof(long).
> > 
> > I was about to suggest that we do something like that...
> > 
> > I wonder how messy it is.  I long ago lost the ability to follow the
> > convolutions in include/linux/spinlock*.h :(  gotta patch?
> 
> The check that's in -rt for this uses BUILD_BUG_ON(), and it's extremely
> cryptic when there is a failure .. Most people will be baffled why the
> build stopped. If a check went into mainline it should at least give you
> some sort of idea what's happening ..

One comment near BUILD_BUG_ON is enough (and everything we can do).

