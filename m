Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbYGPKVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbYGPKVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYGPKU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:20:57 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:50939 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYGPKU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:20:57 -0400
Date: Wed, 16 Jul 2008 11:21:04 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: jkacur <jkacur@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
Message-ID: <20080716102104.GA7477@shadowen.org>
References: <200807161047.21040.jkacur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807161047.21040.jkacur@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 10:47:20AM +0200, jkacur wrote:
> On Wed, Jul 16, 2008 at 10:29 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
> >
> > On Wednesday 2008-07-16 09:19, jkacur wrote:
> >
> >>Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
> >>would use it.
> >
> >>-T:    git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
> >>+T:    git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
> >
> > I would not use it that^ way.
> >
> > -git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
> > +git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
> >
> 
> Yikes! Good catch, thank you, I've respun the patch below.
> 
> Subject: Make the git URL match the usage
> Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
> would use it. They should only have to copy and paste it and not guess how
> to modify it. Secondly, drop the "git" type when the protocol is already git://
> 
> Signed-off-by:John Kacur <jkacur at gmail dot com>
> 
> Index: linux-2.6.26/MAINTAINERS
> ===================================================================
> --- linux-2.6.26.orig/MAINTAINERS
> +++ linux-2.6.26/MAINTAINERS
> @@ -154,7 +154,7 @@ P:	Latchesar Ionkov
>  M:	lucho@ionkov.net
>  L:	v9fs-developer@lists.sourceforge.net
>  W:	http://swik.net/v9fs
> -T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
> +T:	git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>  S:	Maintained

This now looses information.  Although it is obvious that this particular
example (after conversion) is a git repository over git protocol this falls
down for other forms, for example a git repository exported over http://
would appear as below:

    T: http://www.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git

which would be indistiguishable from a quilt series such as Greg KH's
which, if I follow your scheme logically ie. convert it to the same form,
would also be represented as below:

    T: http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

I think your conversion makes sense in that the URL part should be
exactly what one would use with the tool but you still need the tool
designator:

    T: git git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
    T: git http://www.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
    T: guilt http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

-apw
