Return-Path: <linux-kernel-owner+w=401wt.eu-S1161297AbXBADcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161297AbXBADcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 22:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161298AbXBADcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 22:32:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161297AbXBADcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 22:32:07 -0500
Date: Wed, 31 Jan 2007 19:31:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-1?Q?S=2E=C3a=C4lar_Onur?= <caglar@pardus.org.tr>
cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Peter Anvin <hpa@zytor.com>, Mark Huang <mlhuang@CS.Princeton.EDU>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Linux 2.6.20-rc7
In-Reply-To: <200702010501.20994.caglar@pardus.org.tr>
Message-ID: <Pine.LNX.4.64.0701311921090.3632@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org>
 <200702010416.59469.caglar@pardus.org.tr> <Pine.LNX.4.64.0701311828540.3632@woody.linux-foundation.org>
 <200702010501.20994.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1702273712-1170300129=:3632"
Content-ID: <Pine.LNX.4.64.0701311922210.3632@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1702273712-1170300129=:3632
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0701311922211.3632@woody.linux-foundation.org>



On Thu, 1 Feb 2007, S.ÃaÄlar Onur wrote:
> 
> I think i found the cause of the problem, initramfs can't handle hardlinks 
> anymore (which works with 2.6.18), copying same /sbin/busybox binary with 
> different names into initramfs (which ends ups with 50 MB image) or using 
> symbolic ones instead of hards seems works.

Ok, it would still be interesting to hear what triggered this.

There's really only two initramfs-related changes in the whole 2.6.20 
development series that I can see, and neither of them are even _remotely_ 
likely to cause this, afaik. We have:

 - commit 8d610dd52dd1da696e199e4b4545f33a2a5de5c6

   "Make sure we populate the initroot filesystem late enough"

(but "late enough" is still _way_ before we actually mount it, so ..) and

 - commit 2e591bbc0d563e12f5a260fbbca0df7d5810910e

   "Make initramfs printk a warning on incorrect cpio type"

and the latter is just a build-time sanity-check.

Since 2.6.18, there's been a couple more, but none of them look even 
remotely likely either. Which is why it really would be good if you can 
"git bisect" this behaviour.

There _was_ a hardlink-related thing some time ago, but that was back in 
May, and before 2.6.18. So if it worked for you in 2.6.18, I don't see 
that being it.

I've added some initramfs people to the Cc: in case somebody has better 
ideas, but in the absense of that, it really would be good to do that 
bisection. Also, you might want to double-check that your cpio actually 
generates a good initramfs image (it that it's not some user-mode upgrade 
that caused it to stop working).

		Linus
---1463790079-1702273712-1170300129=:3632--
