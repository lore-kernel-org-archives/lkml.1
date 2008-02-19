Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYBSHjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYBSHjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762396AbYBSHin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:38:43 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:49637 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059AbYBSHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:38:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AIzQtkVscgJ8luE6qBAEGalqkTWvzIn/h5Xea+0glyrdEEjOjHGRWVCpb5JEEQF1Hrj1UzgBBq5nAYmZaftJfzgmrrqvjxdbCcNX2JbHvnAK1ISKL6mjIc7MNdzPXSsVx48Yf277WGxcm95rX6LFJlW3FoM9WC/LAP0InIVf/7A=
Message-ID: <84144f020802182338p68d412f6sa9e0f8975344a9c0@mail.gmail.com>
Date: Tue, 19 Feb 2008 09:38:40 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
Cc: "Christoph Lameter" <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Torsten Kaiser" <just.for.lkml@googlemail.com>
In-Reply-To: <1203404594.3248.32.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203058021.3027.143.camel@ymzhang>
	 <Pine.LNX.4.64.0802150839180.12023@schroedinger.engr.sgi.com>
	 <1203404594.3248.32.camel@ymzhang>
X-Google-Sender-Auth: f968e3dbb7a1ac6b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,

> On Fri, 2008-02-15 at 08:42 -0800, Christoph Lameter wrote:
> > > Kernel panic at line 1637 in file mm/slub.c because object=c->freelist=NULL.
> >
> > Hmmmm. freelist should never be NULL. Could you rerun the test and boot with
> > slub_debug to make sure that there is no memory corruption?

On Feb 19, 2008 9:03 AM, Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 1) Without slub_debug option, sometime I could trigger it, sometimes not.
> 2) With slub_debug option, or just enable debug for slab skbuff_fclone_cache
> and skbuff_head_cache, I couldn't trigger it.
>
> I will do more testing and investigation, as the bug also exists in 2.6.25-rc2.

Could you please try Ingo's patch: http://lkml.org/lkml/2008/2/19/13

Looks like there are some problems with SLUB_FASTPATH.

                                    Pekka
