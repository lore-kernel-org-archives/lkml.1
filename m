Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbXFMDSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbXFMDSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 23:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXFMDSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 23:18:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:33658 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbXFMDSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 23:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zk46yhq53IxelnYXN+iwOQCoDKqsRIxavIpHvU8+97taf0KicGwI0yiTCASSs/SneOqJd1KuNxFSJlWsU1QnjFYlAdqpmhYEZOwjUSKpHR1lUVjgem3yKVTxFAsWU7pqdbic6abXp3HeTeoNlZmIlGUURVx0RpmrKuk1CMOr2CY=
Message-ID: <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
Date: Wed, 13 Jun 2007 08:48:29 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Jan Beulich" <jbeulich@novell.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
In-Reply-To: <20070612180002.GC15329@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466E6BDF.76E4.0078.0@novell.com>
	 <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com>
	 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
	 <466EB12B.76E4.0078.0@novell.com>
	 <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
	 <466EC08A.76E4.0078.0@novell.com>
	 <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
	 <20070612180002.GC15329@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 6/12/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, Jun 12, 2007 at 07:39:30PM +0530, Satyam Sharma wrote:
> > On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> > >>> And from a purely theoretical
> > >>> perspective I don't think such references should be considered bad -
> > >>> .exit.* should be discarded together with .init.* if unloading is
> > >>> impossible (built-in or configured off), not before module/kernel
> > >>> initialization.
> > >>
> > >>Hmm, but that's not how things are, presently. __exit marked
> > >>functions are simply not linked into the kernel (when that module
> > >>is being built-in) at all -- this "discard" happens at _build time_
> > >>(to save on kernel image size).
> > >
> > >Not really, at least not for i386 and x86-64 - see their vmlinux.lds.S
> > >files.
> >
> > For those archs, yes, you're right that modpost should be
> > special-casing (based on arch) before complaining for
> > .init -> .exit references.
> No.
> References from __init to __exit is wrong independent on architecture.
[...]
> So for the latter we will have an oops where we for the first have a build
> time failure.

Is that (oops possibility on i386) really true? (.exit.{text, data}) is also
between __init_begin and __init_end and hence will be discarded
_along_ with (not before) .init.{text, data} during run-time I think,
which means .init -> .exit reference modpost warnings (on said
archs) are truly bogus ...

> powerpc discards them at buildtime, i386 at runtime.

Yup, we were only discussing possibility that modpost not complain
about .init -> .exit references that will never go oops (because the arch
guarantees that).

Satyam
