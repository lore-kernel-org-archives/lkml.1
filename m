Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXEBCQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXEBCQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXEBCQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:16:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:32890 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbXEBCQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:16:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fiYso5h7IB/HsA4Bxlj+wDRG+uw7ensHt5/3aLFZ0ICa+h/5tI6Tz0zRcwG/bEnRYtjzrqEu/WNWUqQMAYv24w8k1Cazj2OhZAttVHOHSgqCuR4ZCvt/2ngoMTETSLTULAxLxGuCo31YzckKTBdgP9yB03j3hH1j1d1KkaSyAlQ=
Message-ID: <5c49b0ed0705011916y89212c0v1cec1cb1edae052f@mail.gmail.com>
Date: Tue, 1 May 2007 19:16:32 -0700
From: "Nate Diller" <nate.diller@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] zero_user_page uses in fs/buffer.c and fs/libfs.c
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Satyam Sharma" <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704292313060.3018@schroedinger.engr.sgi.com>
	 <a781481a0704292353v34ea217fpbbf732465dd652e8@mail.gmail.com>
	 <Pine.LNX.4.64.0704300000430.3147@schroedinger.engr.sgi.com>
	 <20070501172643.270bb061.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0705011807550.28210@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 1 May 2007, Andrew Morton wrote:
>
> > As Satyam said, this will sometimes cause us to map and unmap the page
> > twice, and to run flush_dcache_page() twice.  In not-terribly-uncommon
> > circumstances in very frequently called functions.
> >
> > Doesn't seem worth it to me.
>
> Ok but we have that code three times. Should I add a variant of
> zero_user_page that zeroes everything but the section specified?
>
> zero_user_page_allbut() ?

the function already exists, it's called simple_prepare_write(), and i
thought there were patches to convert those callsites in -mm ...
although it looks like i let a review comment on that slide by.  I
need to redo a bunch of patches for re-submission anyway, so i guess
i'll deal with that tomorrow.

NATE
