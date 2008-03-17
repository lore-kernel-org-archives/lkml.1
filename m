Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYCQHbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYCQHbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYCQHbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:31:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:57243 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYCQHbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xAadXKxKbRpWNbhogxmTbVz8kMjRhbdSXugnF8+L9dS32WJgaKZh515TCqYm/Gwsa0XsAy1KUY5yy2D6rb1Q6c1ECJ//Ae9IlLrQDkCoHCmXJAhpW9ltMDbCV4vkfY5B5J/xQMDcYUKL7333PvVFWt/QI6K2gyeS9FhFWmpt/UE=
Message-ID: <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com>
Date: Mon, 17 Mar 2008 00:31:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317258.659191058@firstfloor.org>
	 <20080317015825.0C0171B41E0@basil.firstfloor.org>
	 <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
	 <20080317070208.GC27015@one.firstfloor.org>
	 <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 12:17 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Mon, Mar 17, 2008 at 12:02 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  > > node_boot_start is not page aligned?
>  >
>  >  It is, but it is not necessarily GB aligned and without this
>  >  change sometimes alloc_bootmem when requesting GB alignment
>  >  doesn't return GB aligned memory. This was a nasty problem
>  >  that took some time to track down.
>
>  or preferred has some problem?
>
>
>  preferred = PFN_DOWN(ALIGN(preferred, align)) + offset;
>

when node_boot_start is 512M alignment, and align is 1024M, offset
could be 512M. it seems
i = ALIGN(i, incr) need to do sth with offset...

YH
