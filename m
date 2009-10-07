Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZJGF5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZJGF5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbZJGF5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:57:13 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:55040 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbZJGF5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:57:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: Linux 2.6.32-rc3
Date: Wed, 7 Oct 2009 07:56:31 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hohndel@infradead.org,
       linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910061836.02726.elendil@planet.nl> <3e8340490910061809k6ed6d463v3e357bd703013dca@mail.gmail.com>
In-Reply-To: <3e8340490910061809k6ed6d463v3e357bd703013dca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910070756.32444.elendil@planet.nl>
X-OriginalArrivalTime: 07 Oct 2009 05:56:32.0946 (UTC) FILETIME=[EC180120:01CA4712]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Bryan Donlan wrote:
> On Tue, Oct 6, 2009 at 12:36 PM, Frans Pop <elendil@planet.nl> wrote:
> > BTW, I've got a solution for bisection too: the versions in the
> > Makefile get changed to something constant. And the package version is
> > set equal to the bisection iteration. This ensures that I know exactly
> > which kernels were build for the series and that I can always go back
> > to a specific kernel if I need to retest for some reason.
> >
> > E.g. (for a bisection covering .30-.31):
> > linux-image-2.6.31-bisect_1_amd64.deb
> > linux-image-2.6.31-bisect_2_amd64.deb
> > linux-image-2.6.31-bisect_3_amd64.deb
>
> It should be noted that implementing this would result in the package
> names becoming wildly inconsistent if you bisect over the point where
> this feature is introduced.

It is already supported :-)
But yes, what you note is an issue, though one that automatically fades 
with time. And it is softened by the fact that the scheme is not default. 
The default package versioning was unchanged when the option was added.

> In order to be useful, it would need to 
> determine if its own implementation commit is shadowed by the 'bisect
> good' marker, make a note of this in a non-overwritten location (.git,
> eg), then disable itself and use the old behavior if it would bisect
> over its own introduction.

I deal with it in my wrapper script: that tests if the implementation 
commit is present and, if not [1], replaces scripts/package/builddeb with 
a version that does support it. That works for quite a long time back.
The wrapper script also reverts the change after each build so the 
following good/bad does not fail because the tree is dirty.

Cheers,
FJP

[1] It was introduced with .30: v2.6.30-rc8-79-gc72c75d.
