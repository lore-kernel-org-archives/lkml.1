Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYCCOyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYCCOyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYCCOyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:54:36 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57396 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYCCOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:54:35 -0500
Date: Mon, 3 Mar 2008 07:54:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 11/12] Generic semaphore implementation
Message-ID: <20080303145434.GH24386@parisc-linux.org>
References: <1204180441-8540-3-git-send-email-matthew@wil.cx> <1204180441-8540-4-git-send-email-matthew@wil.cx> <1204180441-8540-5-git-send-email-matthew@wil.cx> <1204180441-8540-6-git-send-email-matthew@wil.cx> <1204180441-8540-7-git-send-email-matthew@wil.cx> <1204180441-8540-8-git-send-email-matthew@wil.cx> <1204180441-8540-9-git-send-email-matthew@wil.cx> <1204180441-8540-10-git-send-email-matthew@wil.cx> <1204180441-8540-11-git-send-email-matthew@wil.cx> <1204252679.20280.115.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204252679.20280.115.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 06:37:59PM -0800, Harvey Harrison wrote:
> > +/*
> > + * Because this function is inlined, the 'state' parameter will be constant,
> > + * and thus optimised away by the compiler.
> > + */
> 
> If so, is unlikely() still needed?

It's needed for the case where the function is inlined into
__down_interruptible / __down_killable.

> Other than that small bit, looks great, any thoughts to getting rid of
> all the likely/unlikely as well?  If they're no longer performance
> critical, it would be nice to have it that little bit cleaner.

I'd rather keep it as close to mutex.c as possible.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
