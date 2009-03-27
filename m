Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbZC0LeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbZC0LeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 07:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbZC0LeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 07:34:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZC0LeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 07:34:09 -0400
Date: Fri, 27 Mar 2009 12:35:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327113553.GB2585@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <20090327003620.GI29836@elf.ucw.cz> <alpine.LRH.2.00.0903271145380.11179@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903271145380.11179@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-03-27 11:46:42, James Morris wrote:
> On Fri, 27 Mar 2009, Pavel Machek wrote:
> 
> > Hi!
> > 
> > > As for the rest of the feedback, please work with the developers to fix 
> > > any bugs or lack of documentation.
> > 
> > Apparently not even its user<->kernel interface was reviewed. This
> > violates "one value per file in sysfs":
> > 
> >     [root@tomoyo]# cat /sys/kernel/security/tomoyo/meminfo
> >     Shared:       61440
> >     Private:      69632
> >     Dynamic:        768
> >     Total:       131840
> >     
> >     You can set memory quota by writing to this file.
> >     (Example)
> >     [root@tomoyo]# echo Shared: 2097152 > /sys/kernel/security/tomoyo/meminfo
> >     [root@tomoyo]# echo Private: 2097152 > /sys/kernel/security/tomoyo/meminfo
> 
> This is not sysfs, it's securityfs, with their documentation showing it 
> mounted on /sys.

Well, that's a bit better, but it still does not justify turning
securityfs into procfs-like mess... when solution is so easy. Just use
one value per file.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
