Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYBAHzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYBAHzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYBAHzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:55:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43331 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbYBAHze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:55:34 -0500
Date: Thu, 31 Jan 2008 23:55:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kenichi Okuyama" <kenichi.okuyama@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] NULL pointer check for vma->vm_mm
Message-Id: <20080131235544.346b938a.akpm@linux-foundation.org>
In-Reply-To: <3fd7d7a70801312339p2a142096p83ed286c81379728@mail.gmail.com>
References: <3fd7d7a70801312339p2a142096p83ed286c81379728@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008 16:39:07 +0900 "Kenichi Okuyama" <kenichi.okuyama@gmail.com> wrote:

> Dear all,
> 
> I was looking at the ./mm/rmap.c .. I found that, in function
> "page_referenced_one()",
>    struct mm_struct *mm = vma->vm_mm;
> was being refererred without NULL check.
> 
> Though I do agree that this works for most of the cases, I thought it
> is better to add
> BUG_ON() for case of mm being NULL.
> 
> attached is the patch for this

If we dereference NULL then the kernel will display basically the same
information as would a BUG, and it takes the same action.  So adding a
BUG_ON here really doesn't gain us anything.

Also, I think vma->vm_mm == 0 is not a valid state, so this just shouldn't
happen - the code is OK to assume that a particular invariant is being
honoured.

