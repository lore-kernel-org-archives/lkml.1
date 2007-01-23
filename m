Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbXAWJS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbXAWJS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932911AbXAWJS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:18:27 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1909 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932907AbXAWJS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:18:26 -0500
Date: Tue, 23 Jan 2007 09:08:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, james.bottomley@steeleye.com,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] binfmt_elf: core dump masking support
Message-ID: <20070123090838.GD5560@ucw.cz>
References: <20061220154056.GA4261@ucw.cz> <45A2EADF.3030807@hitachi.com> <20070109143912.GC19787@elf.ucw.cz> <45A74B89.4040100@hitachi.com> <20070114200157.GA2582@elf.ucw.cz> <45B01387.7010207@hitachi.com> <20070119004548.GE10351@elf.ucw.cz> <45B42194.3050601@hitachi.com> <20070122100610.GC16309@elf.ucw.cz> <45B59218.4040201@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B59218.4040201@hitachi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-01-23 13:42:00, Kawai, Hidehiro wrote:
> Hi,
> 
> >>>(run echo 1 > coremask, echo 0 > coremask in a loop while dumping
> >>>core. Do you have enough locking to make it work as expected?)
> >>
> >>Currently, any lock isn't acquired.  But I think the kernel only
> >>have to preserve the coremask setting in a local variable at the
> >>begining of core dumping.  I'm going to do this in the next version.
> > 
> > No, I do not think that is enough. At minimum, you'd need atomic_t
> > variable. But I'd recomend against it. Playing with locking is tricky.
> 
> Why do you think it is not enough?  I think that any locking is not
> needed.

You are wrong.

>   unsigned int mask = current->mm->coremask;

Not a valid C; coremask can change from another cpu.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
