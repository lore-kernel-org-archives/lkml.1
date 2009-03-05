Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbZCELAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbZCELAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZCELAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:00:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:36364 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZCELAC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:00:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xoqEWWPcCz9amQ1QD2ozdtAnBSn/9+Me5CsLbCj6b6equ5EwuB+LOfPqV1XkrOA3v4
         PypTqk3IgvhCrb3i+1dZOInPQte8fZNlLOE3e3bQfpwoDKH/Y8F/bz8f3sFsZ38ny4jk
         3FTLBV5xjFCDxfv+cj2sDFvZUK1BozKcbQALU=
MIME-Version: 1.0
In-Reply-To: <49AEBB8C.2000405@codemonkey.ws>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
	 <200902282309.07576.nickpiggin@yahoo.com.au>
	 <49AB19E1.4050604@goop.org>
	 <200903021737.24903.nickpiggin@yahoo.com.au>
	 <49AB9336.7010103@goop.org> <49AEBB8C.2000405@codemonkey.ws>
Date: Thu, 5 Mar 2009 10:59:58 +0000
X-Google-Sender-Auth: 728001427f84625d
Message-ID: <de76405a0903050259j5a0f9649v28e8f8fd29003d5f@mail.gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: core dom0 support
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 5:34 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> Can you point to benchmarks?  I have a hard time believing this.
>
> How can shadow paging beat nested paging assuming the presence of large
> pages?

If these benchmarks would help this discussion, we can certainly run
some.  As of last Fall, even with superpage support, certain workloads
perform significantly less well with HAP (hardware-assisted paging)
than with shadow pagetables.  Examples are specjbb, which does almost
no pagetable updates, but totally thrashes the TLB.  SysMark also
performed much better with shadow pagetables than HAP.  And of course,
64-bit is worse than 32-bit.  (It's actually a bit annoying from a
default-policy perspective, since about half of our workloads perform
better with HAP (up to 30% better) and half of them perform worse (up
to 30% worse)).

Our comparison would, of course, be comparing Xen+HAP to Xen+Shadow,
which isn't necessarily comparable to KVM+HAP.

Having HAP work well would be great for us as well as KVM.  But
there's still the argument about hardware support: Xen can run
paravirtualized VMs on hardware with no HVM support, and can run fully
virtualized domains very well on hardware that has HVM support but not
HAP support.

 -George Dunlap
