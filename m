Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbXEWKSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbXEWKSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758439AbXEWKSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:18:25 -0400
Received: from web52611.mail.re2.yahoo.com ([206.190.48.214]:29109 "HELO
	web52611.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758223AbXEWKSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:18:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=6NK63xihzgAeaHZX2WDYGu84842uMuywVI2s2r/sSft94nLscExe72wqSTo68lXJVpH29zYaZxyn72KJ7vKTDbbxyGJWgzLfZ0nJHJ8TFQTD1IhewQz2k+O2pJ5LmbjSypNQIhVc5xRSTvEAeTyVCsb/gmZ2ta6h/KCyv38/OlY=;
X-YMail-OSG: _RXArGAVM1lcUzPjJHhGs8lzqffqzt67iV2RTKcbCLFU1KLYhIw2tOqmLWL8wRhf0A--
Date: Wed, 23 May 2007 20:18:23 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <294534.72400.qm@web52611.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Christoph Lameter <clameter@sgi.com> wrote:
> On Wed, 23 May 2007, Srihari Vijayaraghavan wrote:
[...]
> Yup. compile with
> 
> CONFIG_NUMA
> 
> CONFIG_LOCKDEP
> 
> CONFIG_DEBUG_LOCK_ALLOCS

(All the tests in this email was conducted on top of your patch)

Yup done that. The resulting kernel (without CONFIG_SLUB_DEBUG=y) is quite
stable; passed a few iterations of kernel compile tests successfully.

> and then try to boot without slub_debug.

I guess you mean with CONFIG_SLUB_CONFIG=y? If so, I built another kernel with
CONFIG_SLUB_DEBUG=y (plus all of the above) & tested it. It panics by default,
but with slub_nomerge it works just fine (tested under moderate load).

(the panic message produced by CONFIG_SLUB_DEBUG=y was the exact same call
trace as my very first email in this email thread with slightly different
address on a couple of functions, but rest remains the same)

I'm personally very happy that slub works stably without slub debug options,
because that's what I'd run in a production env. Thanks to your patch, slub is
quite stable without the slub debug for me :-)). But it'd to nice to have a
working slub debug for test env., as you'd undoubtedly be aware of, of course
:-). Just my humble opinion.

> If that fails then boot with slub_nomerge

Yup, I had to use slub_nomerge; without that CONFIG_SLUB_DEBUG=y kernel
panics. (I haven't tested the UP case though. I did try nosmp & maxcpus=1, but
they had no effect on the panic. Do you want me to test UP case for
CONFIG_SLUB_DEBUG=y without slub_nomerge?)

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

