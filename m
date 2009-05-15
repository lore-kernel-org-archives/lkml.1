Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbZEOG4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbZEOG4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZEOG4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:56:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40895 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZEOG4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:56:01 -0400
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Josef Bacik <josef@redhat.com>, sandeen@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
From: Andi Kleen <andi@firstfloor.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com>
	<1242317939-15392-3-git-send-email-v.mayatskih@gmail.com>
Date: Fri, 15 May 2009 08:56:00 +0200
In-Reply-To: <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> (Vitaly Mayatskikh's message of "Thu, 14 May 2009 18:19:01 +0200")
Message-ID: <87k54iq2gv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Mayatskikh <v.mayatskih@gmail.com> writes:

> This patch changes iov_iter_fault_in_readable() to use check_readable_bytes()
> instead of fault_in_pages_readable(). It allows iov_iter_fault_in_readable()
> callers to know how much data is accessible and proceed with it. It makes
> sys_write() more POSIX-friendly.

Can you describe how it makes it POSIX friendly?

My understanding was that EFAULT behaviour was undefined in POSIX.

The obvious hole in the patch is that all these checks are not race
free -- they don't pin pages -- so if there's a parallel unmap even
with your change they can still fail in the middle.

-Andi 

-- 
ak@linux.intel.com -- Speaking for myself only.
