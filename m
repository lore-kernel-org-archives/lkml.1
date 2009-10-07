Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbZJGBKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbZJGBKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZJGBKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:10:17 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:34750 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbZJGBKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:10:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=RMIIa6q7CKLczj4aLZlkkxSgPqgrEtkBm7ULbXhTqthQgNbhi+lGe9oRSGYFaVg6cS
         R5I45NQAqZoTPvoMFowv5UWa7GARm/Bx0cP2li9chfJdRcNDSEh3pEORuCc1G+BmWDy9
         QuXJ08I+9z0xM85jKnmfzKBB9AiYp5kitHhqI=
MIME-Version: 1.0
In-Reply-To: <200910061836.02726.elendil@planet.nl>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> 
	<alpine.LFD.2.00.0910052140100.309@localhost.localdomain> 
	<1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> 
	<alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> 
	<1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com> 
	<alpine.LFD.2.01.0910060808220.3432@localhost.localdomain> 
	<200910061836.02726.elendil@planet.nl>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 6 Oct 2009 21:09:18 -0400
Message-ID: <3e8340490910061809k6ed6d463v3e357bd703013dca@mail.gmail.com>
Subject: Re: Linux 2.6.32-rc3
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hohndel@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 12:36 PM, Frans Pop <elendil@planet.nl> wrote:

> BTW, I've got a solution for bisection too: the versions in the Makefile
> get changed to something constant. And the package version is set equal to
> the bisection iteration. This ensures that I know exactly which kernels
> were build for the series and that I can always go back to a specific
> kernel if I need to retest for some reason.
>
> E.g. (for a bisection covering .30-.31):
> linux-image-2.6.31-bisect_1_amd64.deb
> linux-image-2.6.31-bisect_2_amd64.deb
> linux-image-2.6.31-bisect_3_amd64.deb

It should be noted that implementing this would result in the package
names becoming wildly inconsistent if you bisect over the point where
this feature is introduced. In order to be useful, it would need to
determine if its own implementation commit is shadowed by the 'bisect
good' marker, make a note of this in a non-overwritten location (.git,
eg), then disable itself and use the old behavior if it would bisect
over its own introduction.
