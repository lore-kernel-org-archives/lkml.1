Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbYAWSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbYAWSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYAWSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:04:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752583AbYAWSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:04:26 -0500
Date: Wed, 23 Jan 2008 10:03:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Salikhmetov <salikhmetov@gmail.com>
cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v8 2/4] Update ctime and mtime for memory-mapped files
In-Reply-To: <12010440822957-git-send-email-salikhmetov@gmail.com>
Message-ID: <alpine.LFD.1.00.0801230959500.1741@woody.linux-foundation.org>
References: <12010440803930-git-send-email-salikhmetov@gmail.com> <12010440822957-git-send-email-salikhmetov@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2008, Anton Salikhmetov wrote:
>
> Update ctime and mtime for memory-mapped files at a write access on
> a present, read-only PTE, as well as at a write on a non-present PTE.

Ok, this one I'm applying. I agree that it leaves MS_ASYNC not updating 
the file until the next sync actually happens, but I can't really bring 
myself to care at least for an imminent 2.6.24 thing. The file times are 
actually "correct" in the sense that they will now match when the IO is 
done, and my man-page says that MS_ASYNC "schedules the io to be done".

And I think this is better than we have now, and I don't think this part 
is somethign that anybody really disagrees with.

We can (and should) keep the MS_ASYNC issue open.

		Linus
