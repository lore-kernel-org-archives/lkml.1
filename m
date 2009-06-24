Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbZFXX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbZFXX5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZFXX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:57:23 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51111 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZFXX5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:57:22 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 24 Jun 2009 16:52:06 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090624161240.3efdbbfa.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906241636060.30928@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131239.711d9f83.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
 <20090623142511.c9068655.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231423490.17001@makko.or.mcafeemobile.com> <20090623144416.04c34268.akpm@linux-foundation.org> <alpine.DEB.1.10.0906231538280.17001@makko.or.mcafeemobile.com>
 <20090623161852.660cab78.akpm@linux-foundation.org> <alpine.DEB.1.10.0906241546380.30928@makko.or.mcafeemobile.com> <20090624161240.3efdbbfa.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Andrew Morton wrote:

> Split what?  My skull?

Heh :)


> umm, yes please, I believe the patches should be split.  And I'm still
> not seeing the justification for forcing CONFIG_EVENTFD onto all
> CONFIG_AIO users!

Eventfd notifications became part of the AIO API (it's not even delivered 
through a new syscall, from the AIO side - same existing aiocb struct and 
io_submit syscall) once we merged it, so IMHO (AIO && !EVENTFD) would be 
similar to split AIO in AIO_READ and AIO_WRITE and have (AIO && !AIO_WRITE).
Considering that the kernel config, once you unleash the CONFIG_EMBEDDED 
pandora box, allows you to select (AIO && !EVENTFD) w/out even a warning 
about possible userspace breakages, this makes it rather a confusing 
configuration if you ask me.
It's not a biggie from the kernel side, just a few ugly errors wrappers 
around functions. For me AIO (or whatever userspace visible kernel 
subsystem) should select all the components that are part of the userspace 
API, but my argument ends here.



- Davide


