Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXKDSGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXKDSGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbXKDSGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:06:31 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:6243 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXKDSGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n36poz6Ryut4I8sf+bQ0ePRDfuXnsdPTOV4BCctq4xheYutQR7iKiWxFNJvVW0FtupxQjzUldmuHV7m0v9l/rxtwBo1Od2W0TjMzJGXuqG92imjqh4l7RhSwQ0e7XN9h9qcLFFMDIFsEcxvoQx2s23UI+es+z9OFxeYe46Xe7IY=
Message-ID: <e2e108260711041006i4135f347gd101f061b0b503da@mail.gmail.com>
Date: Sun, 4 Nov 2007 19:06:28 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Is gcc thread-unsafe?
Cc: "Andrew Haley" <aph@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tomash Brechko" <tomash.brechko@gmail.com>
In-Reply-To: <alpine.LFD.0.999.0711040943540.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <18210.2314.57767.962503@zebedee.pink>
	 <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
	 <18215.1394.294830.944162@zebedee.pink>
	 <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
	 <18219.17505.443550.620503@zebedee.pink>
	 <e2e108260711040713g2802b262sda75672f8e0f50f6@mail.gmail.com>
	 <alpine.LFD.0.999.0711040943540.15101@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> On Sun, 4 Nov 2007, Bart Van Assche wrote:
> >
> > Has it already been decided who will do this audit, and when this
> > audit will happen ? Has a target date been set when this audit should
> > be complete, or is the completion of this audit a requirement for the
> > release of a specific gcc version ?
>
> I am told that the gcc people realized that was indeed a bug (people were
> able to show problems even in non-threaded environments with mprotect()),
> and have now fixed it in the current gcc sources. That still leaves the
> old versions with potential problems, but I think it makes it much less
> interesting to audit for these things.
>
>                 Linus

What I understood from the gcc mailing list is that a patch has been
applied to the gcc sources that solves the issue with speculative
stores that was already discussed here on the LKML
(http://gcc.gnu.org/ml/gcc/2007-10/msg00554.html).

But the issue I am referring to is a different issue: namely that a
compiler optimization called register promotion can introduce data
races. Hans J. Boehm has a clear explanation of this -- see also
paragraph 4.3 in
http://www.hpl.hp.com/techreports/2004/HPL-2004-209.pdf or
http://portal.acm.org/citation.cfm?id=1064978.1065042 .

Bart Van Assche.
