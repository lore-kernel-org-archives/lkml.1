Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYHEIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYHEIqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 04:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758877AbYHEIqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 04:46:22 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:55403
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757662AbYHEIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 04:46:19 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2008 04:46:19 EDT
Date: Tue, 5 Aug 2008 10:39:46 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: initramfs optimization suggestions
Message-ID: <20080805083946.GC3165@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Frans Meulenbroeks <fransmeulenbroeks@gmail.com>,
	linux-kernel@vger.kernel.org
References: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac9c93b10808050042u496bfa10nad7962eb0e9ec015@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans

El Tue, Aug 05, 2008 at 09:42:11AM +0200 Frans Meulenbroeks ha dit:

> [Upfront apologies if this is the wrong place to post this to.Just
> give me a gentle redirect to the right place in that case.]
> 
> I've been looking into improving the boot time of an embedded linux
> system (monta vista based).
> While doing so I detected that initramfs initialisation was one of the
> places where a lot of time was spent, so I looked into it in some more
> detail and came up with the following findings & suggestions.
> 
> First proposal:
> ==========
> 
> initramfs is build from a compressed cpio archive.
> Proposal is to introduce a build option to make the compression and
> decompression optional.
> Rationale 1: could be faster as it trades off I/O time (to read the
> image) against decompression time
> Rationale 2: for architectures that use compressed images (bzImage)
> actually we compress twice, which is not really efficient.
> 
> I can implement this, but before spending time on it I would like to know if
> a) people consider this a good idea
> b) no one else already has doen this.
> 
> 
> Second proposal:
> ============
> 
> after decompressing the cpio archive all files are made using
> sys_open/sys_write/sys_close and friends.
> This implies that a lot of system calls and data copying is done.
> It would be nice if that could be avoided.
> I'm not fully into all details of how ramfs is implemented, but would
> it be possible to e.g. dump all blocks of a tmp ram fs into a data
> structure (e.g.an array of blocks) while making the kernel, and while
> booting the kernel initialise the fs cache with these data? (I guess
> this would be around fs/dcache.c; I understand the data here is
> kmalloc-ed, but it might be possible to initialise the cache with
> pointers to that data structure; due to the nature of ramfs they won't
> be deallocated anyway I assume).
> Does this sound feasible? Hidden snags? Appreciate your
> opinion/feedback/suggestions.
> 
> Best regards, Frans.
> 
> PS: if anyone has a pointer to a place which explains in full detail
> how linux fs internally works (apart from the source :-) ) I
> appreciate a reference. FM

you might want to get in touch with Robert P. J. Day
(rpjday@crashcourse.ca>) who is also working on initramfs
optimizations. see a recent thread on the kernelnewbies mailing list: 
http://article.gmane.org/gmane.linux.kernel.kernelnewbies/26978

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
