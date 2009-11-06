Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZKFNL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZKFNL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKFNL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:11:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZKFNL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:11:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
Date: Fri, 6 Nov 2009 14:11:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <m1tyx8trik.fsf@fess.ebiederm.org> <200911061310.02785.arnd@arndb.de> <m1ljij24p0.fsf@fess.ebiederm.org>
In-Reply-To: <m1ljij24p0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061411.19580.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18lpTwSTTNzRQxC5RQW7roEy80oxeW04OuFSCF
 iQvpYkwvmjNnaVKu9Hctals2vCyltaYwXDcIsIHI1R76ZZvfUg
 usKwsmYA9kS8HFyJ4zdsw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009, Eric W. Biederman wrote:
> The primary proc path already doesn't need the lock_kernel().  My next
> patch winds up killing the entire binary path and rebuilding on top of
> /proc/sys.  Which removes that lock_kernel().
> 
> Which I think elegantly solves all of the sysctl BKL lock issues.

Yes, that sounds like an excellent plan, but I'm not completely sure
if the lack of the BKL in the procfs case is intentional. As a
particular case that I stumbled over, 'core_pattern' is read
with the BKL held to protect against sysctl changing it, but
it is changed with proc_dostring without the BKL.

Most uses of intvec or string seem to be racy and probably need
a proper serialization method anyway.

	Arnd <><
