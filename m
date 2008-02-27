Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYB0EN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYB0EN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYB0ENS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:13:18 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37598 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYB0ENR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:13:17 -0500
Date: Tue, 26 Feb 2008 21:13:16 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline __attribute__((format (printf,x,y) to statement expression macros
Message-ID: <20080227041316.GA23188@parisc-linux.org>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204084947.19319.411.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 08:02:27PM -0800, Joe Perches wrote:
> Converting inline __attribute__((format (printf,x,y) functions
> to macros or statement expressions produces smaller objects
> 
> before:
> $ size vmlinux
>    text    data     bss     dec     hex filename
> 4716770  474560  618496 5809826  58a6a2 vmlinux
> after:
> $ size vmlinux
>    text    data     bss     dec     hex filename
> 4716706  474560  618496 5809762  58a662 vmlinux

> -static inline void __attribute__((format(printf, 1, 2)))
> -__simple_attr_check_format(const char *fmt, ...)
> -{
> -	/* don't do anything, just let the compiler check the arguments; */
> -}
> +/* don't do anything, just let the compiler check the arguments; */
> +
> +#define __simple_attr_check_format(fmt, args...) \
> +	do { if (0) printk(fmt, ##args); } while (0)

That's very interesting.  It's only 64 bytes, but still, it's not
supposed to have any different effect.  Could you distill a test case
for the GCC folks and file it in their bugzilla?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
