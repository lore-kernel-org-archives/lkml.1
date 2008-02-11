Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYBKSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYBKSPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbYBKSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:15:39 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:46302 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbYBKSPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:15:37 -0500
Date: Mon, 11 Feb 2008 11:15:26 -0700
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [sample] mem_notify v6: usage example
In-reply-to: <2f11576a0802090846t7655e988pb1b712696cad1098@mail.gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jon Masters <jonathan@jonmasters.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Al Boldi <a1426z@gawab.com>,
       Zan Lynx <zlynx@acm.org>
Message-id: <20080211181526.GC3029@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <2f11576a0802090755n123c9b7dh26e0af6a2fef28af@mail.gmail.com>
 <CE520A17-98F2-4A08-82AB-C3D5061616A1@jonmasters.org>
 <2f11576a0802090846t7655e988pb1b712696cad1098@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10, 2008  01:46 +0900, KOSAKI Motohiro wrote:
> > This really needs to be triggered via a generic kernel event in the
> > final version - I picture glibc having a reservation API and having
> > generic support for freeing such reservations.
> 
> to be honest, I doubt idea of generic reservation framework.
> 
> end up, we hope drop the application cache, not also dataless memory.
> but, automatically drop mechanism only able to drop dataless memory.
> 
> and, many application have own memory management subsystem.
> I afraid to nobody use too complex framework.

Having such notification handled by glibc to free up unused malloc (or
any heap allocations) would be very useful, because even if a program
does "free" there is no guarantee the memory is returned to the kernel.

I think that having a generic reservation framework is too complex, but
hiding the details of /dev/mem_notify from applications is desirable.
A simple wrapper (possibly part of glibc) to return the poll fd, or set
up the signal is enough.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

