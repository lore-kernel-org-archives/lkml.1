Return-Path: <linux-kernel-owner+w=401wt.eu-S935816AbZAPRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbZAPRkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZAPRkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:40:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZAPRkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:40:19 -0500
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
In-Reply-To: <20090116093550.ce7229d5.akpm@linux-foundation.org>
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
	 <496F8AED.3020604@oracle.com>
	 <1232101203.3554.3.camel@localhost.localdomain>
	 <20090116084352.9f35b822.akpm@linux-foundation.org>
	 <1232125371.9571.587.camel@quoit> <4970BE8F.9090705@oracle.com>
	 <20090116093550.ce7229d5.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 16 Jan 2009 17:37:07 +0000
Message-Id: <1232127427.9571.589.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-01-16 at 09:35 -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 09:06:23 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > >>> which is not ideal, but I don't see any easy way to avoid the #ifdef,
> > >>>
> > >> Take a look in fs.h:
> > >>
> > >> #define generic_setlease(a, b, c) ({ -EINVAL; })
> > >>
> > >> If that wasn't a stupid macro, your code would have compiled and ran
> > >> just as intended.
> > >>
> > > There doesn't seem to be an easy answer though. If I #define it to NULL,
> > > that upsets other parts of the code that rely on that macro, and if I
> > > turn it into a inline function which returns -EINVAL, then presumably I
> > > can't take its address for my file_operations.
> > 
> > No, gcc will allow &inline_func and out-of-line it if it is needed (AFAIK;
> > I've seen a few cases of that).
> > 
> 
> yup.  It measn that we'll get a separate private copy of the
> generic_setlease() code in each compilation unit which takes its
> address, but I don't think that would kill us.
> 
> The prevention is of course to put the stub function in a core kernel
> .c file and export it to modules.
> 
Ok, I'll have another look at this and try and cook something up,

Steve.


