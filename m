Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbYJGG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbYJGG2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYJGG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 02:28:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59199 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYJGG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 02:28:13 -0400
To: Richard Holden <aciddeath@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: BKL still required for what functions?
From: Andi Kleen <andi@firstfloor.org>
References: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com>
Date: Tue, 07 Oct 2008 08:28:11 +0200
In-Reply-To: <F99FEC4F-DEDD-4E55-93B4-A0761F30E1A2@gmail.com> (Richard Holden's message of "Mon, 6 Oct 2008 22:24:12 -0600")
Message-ID: <87ljx0nclg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Holden <aciddeath@gmail.com> writes:

> I'm doing some driver cleanup on the ixj telephony driver, mostly
> copy/ paste and common code refactoring. I'm also looking at trying to
> get  rid of the BKL from the 2 places its used, so I was wondering if
> we  have a list of kernel calls that still require the BKL to be held,
> and  if we don't have a list would it be worthwhile to put one into
> Documentation, I'd be willing to maintain the list as we removed the
> BKL from the last core kernel places.

The standard answer is to check the callers. 

But in general there are very little (in fact I cannot think of any)
general kernel utility functions left that need the BKL and if they
then usually take it on their own. So you should be ok
assuming that general kernel code (e.g. code living in kernel/*
or lib/*) doesn't need it.

If you rely on other driver frameworks that might be different,
but a good rule of thumb is to just check that directly if it 
uses lock_kernel at all.

The reason that a lot of driver code still uses BKL implicitely
(e.g. in ioctl code) is more because it always needs someone 
to audit.

-Andi

-- 
ak@linux.intel.com
