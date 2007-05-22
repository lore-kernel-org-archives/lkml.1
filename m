Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbXEVRE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbXEVRE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 13:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbXEVREW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 13:04:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:51188 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbXEVREV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 13:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=buGCZCznCwxYND8cDqcaciovlHU2qzbZA1QePWzqWJdQ/nCD0/9HvIN9OvX0poCD/WU1gEXzTfnCLmoQnZGlDHX7/zAy0sgrxLI2JTfdWIaSpGxdqn59u5YXp+nlDJFK7sKhFLxdmWm0VSaj9NSzzky8NmAeN1fP/iXtpWf6J84=
Message-ID: <a781481a0705221004t4058154akb8b142dfdd2d6073@mail.gmail.com>
Date: Tue, 22 May 2007 22:34:19 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070522161951.GC2098@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <20070522135927.GA2098@stusta.de>
	 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	 <20070522161951.GC2098@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, May 22, 2007 at 10:04:16AM -0400, Robert P. J. Day wrote:
> > On Tue, 22 May 2007, Adrian Bunk wrote:
> >
> > > On Tue, May 22, 2007 at 09:09:22AM -0400, Robert P. J. Day wrote:
> > > >
> > > >   given that:
> > > >
> > > > $ grep -r "define.*NORET_TYPE" *
> > > > include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> > > > include/linux/linkage.h:#define NORET_TYPE    /**/
> > > > include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> > > > $
> > > >
> > > > is there any obvious value to the 30 or so uses of that macro
> > > > sprinkled throughout the tree?
> > >
> > > I can be mistaken, but it seems the uses should be replaced with your
> > > __noreturn
> >
> > no, i think you're thinking of the alternative ATTRIB_NORET macro.
> > as you can read in my previous post, NORET_TYPE used to resolve to
> > "__volatile__" for very old gcc.  so i think it's legitimately dead
> > and can be ripped out.
>
> No doubt that it could be removed because it doesn't have any effect.
>
> But locking at the usages, it seems to have been used when people
> thought it was what __noreturn now is, so replacing NORET_TYPE with
> __noreturn might be a small optimization (but every NORET_TYPE should
> be checked that it's actually correct).

Adrian's right, and in fact from ...

http://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html

... we know why that macro existed and evaluated to __volatile__
for pre-2.5 gcc. Perhaps most of today's users of NORET_TYPE were
probably looking for ATTRIB_NORET (which is quite common) actually.

[ __noreturn is defined in compiler-gcc.h, so the easier way would be
to kill NORET_TYPE and replace its usages with ATTRIB_NORET instead.
Of course, after verifying that the function _really_ never returns. ]
