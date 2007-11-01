Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXKAQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXKAQOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXKAQNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:13:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbXKAQNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:13:52 -0400
Message-ID: <4729FB43.1010904@redhat.com>
Date: Thu, 01 Nov 2007 14:13:55 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ak@suse.de, chrisw@sous-sol.org, tglx@linutronix.de,
       anthony@codemonkey.ws, akpm@linux-foundation.org,
       virtualization@lists.linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 3/16] read/write_crX, clts and wbinvd for 64-bit paravirt
References: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C34FAA4C.17CA9%Keir.Fraser@cl.cam.ac.uk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Keir Fraser escreveu:
> On 1/11/07 15:30, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> 
>> Glauber de Oliveira Costa wrote:
>>> I in fact have seen bugs with mixed reads and writes to the same cr,
>>> (cr4), but adding the volatile
>>> flag to the read function seemed to fix it.
>> Well, volatile will make a read be repeated rather than caching the
>> previous value, but it has no effect on ordering.
> 
> volatile prevents the asm from being 'moved significantly', according to the
> gcc manual. I take that to mean that reordering is not allowed.
> 
According to a gcc developer to whom I asked this question, volatile
prevents the code
to be removed, but does not prevent it to be moved (pun indented). In
practice, it should force
a re-read, but not influence the ordering decisions from the compiler.
Besides , 'significantly'
sounds like a significantly unprecise word, whose specific meaning may
be implementation dependant.

So I agree that adding a memory location reference is probably the best
alternative.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHKftDjYI8LaFUWXMRAiLTAKDqf/M8umNYw6u7r9ONozTEUVy8SwCgygma
jWNKQmxmLpyPxr00KbQy9Vg=
=JM4K
-----END PGP SIGNATURE-----
