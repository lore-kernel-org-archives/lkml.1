Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbXEBC1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbXEBC1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbXEBC1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:27:18 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:37495 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbXEBC1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:27:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KBXzTG6A2jY0kJREr7sNRWczzatJ1A+GA/vj0TQsmC+IQM31fLa4Ky0Yg81Xv3RyjAX8XlmxX11c9738iJFTAdl6pvkpMWIQPT+Vky5G1s8gca42zlQLt80FwFovUtSB8aSE2SoCcPNDo4SfJM/TTyij2do1fWB+nOdCoYOIky8=
Message-ID: <5c49b0ed0705011927n66208c1egd7cfdb6985dc901b@mail.gmail.com>
Date: Tue, 1 May 2007 19:27:16 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <5c49b0ed0705011916y89212c0v1cec1cb1edae052f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
	 <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
	 <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
	 <20070501172643.270bb061.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com>
	 <5c49b0ed0705011916y89212c0v1cec1cb1edae052f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Nate Diller <nate.diller@gmail.com> wrote:
> On 5/1/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Tue, 1 May 2007, Andrew Morton wrote:
> >
> > > As Satyam said, this will sometimes cause us to map and unmap the page
> > > twice, and to run flush_dcache_page() twice.  In not-terribly-uncommon
> > > circumstances in very frequently called functions.
> > >
> > > Doesn't seem worth it to me.
> >
> > Ok but we have that code three times. Should I add a variant of
> > zero_user_page that zeroes everything but the section specified?
> >
> > zero_user_page_allbut() ?
>
> the function already exists, it's called simple_prepare_write(), and i
> thought there were patches to convert those callsites in -mm ...
> although it looks like i let a review comment on that slide by.  I
> need to redo a bunch of patches for re-submission anyway, so i guess
> i'll deal with that tomorrow.
>
> NATE
>

well, leave it to me to reply too quickly, sorry.  i think we should
leave simple_prepare_write() the way it is, since it's a library
function itself.  the other two callsites in your patch are buffers,
which may themselves be smaller than a page so you would need a
special function for just those two uses, there's no other way to
avoid making two calls to flush_dcache_page().  if it's tremendously
important to you to eliminate open coding of these, maybe make a
'static int buffer_prepare_write()' or some such in fs/buffer.c

NATE
