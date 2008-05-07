Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYEGQin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYEGQin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYEGQia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:38:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46438 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYEGQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:38:29 -0400
Date: Wed, 7 May 2008 10:38:12 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507163811.GY19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506102153.5484c6ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 10:21:53AM -0700, Andrew Morton wrote:
> up() seems to be doing wake-one, FIFO which is nice.  Did the
> implementation which we just removed also do that?  Was it perhaps
> accidentally doing LIFO or something like that?

If heavily contended, it could do this.

up() would increment sem->count and cal __up() which would call wake_up()
down() would decrement sem->count.
The unlucky task woken by __up would lose the race and go back to sleep.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
