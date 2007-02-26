Return-Path: <linux-kernel-owner+w=401wt.eu-S1161161AbXBZVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161161AbXBZVgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161201AbXBZVgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:36:32 -0500
Received: from smtpout.mac.com ([17.250.248.184]:53764 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161161AbXBZVgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:36:31 -0500
In-Reply-To: <45E32AFD.2050407@zytor.com>
References: <Pine.LNX.4.64.0701282200450.17167@sbz-30.cs.Helsinki.FI> <20070226003307.6f38d2ee@lxorguk.ukuu.org.uk> <84144f020702252325j29da2819i50c99477cce89359@mail.gmail.com> <45E291F7.6060508@zytor.com> <79B7BBDC-E953-4EAE-8D32-E510DE0981FF@zabbo.net> <20070226194131.2c4e4a47@lxorguk.ukuu.org.uk> <45E32AFD.2050407@zytor.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4182E03E-A471-458C-98E6-4524C10BBE9A@mac.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Zach Brown <zab@zabbo.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@lst.de
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [RFC/PATCH] revokeat/frevoke system calls V5
Date: Mon, 26 Feb 2007 16:36:05 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 26, 2007, at 13:46:21, H. Peter Anvin wrote:
> Alan wrote:
>>> I'm not sure.  Turning, for example, the statat(dir_fd, name ==  
>>> NULL)  error case into fstat(dir_fd) sounds like a way for apps,  
>>> admittedly  buggy ones, to be surprised.  Maybe libc would be  
>>> exptected to catch  the error before performing the shared system  
>>> call?
>> At that point would it not be cheaper to have two system calls,  
>> the table cost isn't very large.
>
> It's not just the table, though, you need two entry points, but  
> even that isn't really all that big either, I guess.

Well, I suppose there are multiple possibilities for consolidation:
   frevokeat(fd, "/foo/bar/baz") => normal frevokeat
   frevokeat(-1, "/foo/bar/baz")	=> revoke("/foo/bar/baz");
   frevokeat(fd, NULL)		=> frevoke(fd);

Neither of those would ordinarily be considered to do anything useful  
and for new syscalls I can't see the possibility of breaking existing  
programs.  On the other hand, it's not like we have any problems with  
the syscall tables getting too large.

Cheers,
Kyle Moffett

