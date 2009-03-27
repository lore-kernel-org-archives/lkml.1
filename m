Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbZC0Adp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbZC0Adp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933212AbZC0Add
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:33:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34044 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbZC0Adc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:33:32 -0400
Date: Fri, 27 Mar 2009 01:36:20 +0100
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: TOMOYO in linux-next
Message-ID: <20090327003620.GI29836@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> As for the rest of the feedback, please work with the developers to fix 
> any bugs or lack of documentation.

Apparently not even its user<->kernel interface was reviewed. This
violates "one value per file in sysfs":

    [root@tomoyo]# cat /sys/kernel/security/tomoyo/meminfo
    Shared:       61440
    Private:      69632
    Dynamic:        768
    Total:       131840
    
    You can set memory quota by writing to this file.
    (Example)
    [root@tomoyo]# echo Shared: 2097152 > /sys/kernel/security/tomoyo/meminfo
    [root@tomoyo]# echo Private: 2097152 > /sys/kernel/security/tomoyo/meminfo

(not to mention being ugly as hell).

This is totaly useless once tomoyo is merged:

    ** /sys/kernel/security/tomoyo/version **
    
    This file is used for getting TOMOYO Linux's version.
    (Example)
    [root@etch]# cat /sys/kernel/security/tomoyo/version
    2.2.0-pre


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
