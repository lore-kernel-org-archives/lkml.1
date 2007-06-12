Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbXFLOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbXFLOJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXFLOJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:09:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:30356 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbXFLOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HiGcZgsiTAa2E0iyFGsVs7msHXmdep3aMB2uavxtdj+/ozF7kfid5UsYFh+0WXZCiAJyz31P0BXn+teABpO7n9TC18Q3bNtv1HI25FiNC9dwd9Ei4SVqk2VEWA5ohUIq7gAkWvvbMEYOnbYTE3Hi7E+5nwJMlCLXYLmBHkahZUA=
Message-ID: <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
Date: Tue, 12 Jun 2007 19:39:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: fix improper .init-type section references
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
In-Reply-To: <466EC08A.76E4.0078.0@novell.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> >> And from a purely theoretical
> >> perspective I don't think such references should be considered bad -
> >> .exit.* should be discarded together with .init.* if unloading is
> >> impossible (built-in or configured off), not before module/kernel
> >> initialization.
> >
> >Hmm, but that's not how things are, presently. __exit marked
> >functions are simply not linked into the kernel (when that module
> >is being built-in) at all -- this "discard" happens at _build time_
> >(to save on kernel image size).
>
> Not really, at least not for i386 and x86-64 - see their vmlinux.lds.S files.

For those archs, yes, you're right that modpost should be
special-casing (based on arch) before complaining for
.init -> .exit references.
