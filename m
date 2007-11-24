Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbXKXQLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbXKXQLt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 11:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbXKXQLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 11:11:41 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:8395 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbXKXQLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 11:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZUf9UfZNKx/UF04JyxE5e+qy6mR+4jArJE/DZdyMySzx9peldh2j/5Aph79/fxZr3GcP6qzqBCOrpU3dtBprJQDxocNxMOIyf9IYRnjlo4SoTiihAG4IjKpcB4cgxDMvHUhoS5WkMnC/7521WLeWyoH9cOBNXltisu8D/AaPkgo=
Message-ID: <a36005b50711240811g1fdca17fwe8534ebe8ece6432@mail.gmail.com>
Date: Sat, 24 Nov 2007 08:11:38 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCHv5 4/5] Allow setting O_NONBLOCK flag for new sockets
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
In-Reply-To: <4747E0C6.5010900@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711210728.lAL7SoJO015052@devserv.devel.redhat.com>
	 <4747D00D.1090603@cosmosbay.com> <4747D610.6040108@redhat.com>
	 <4747E0C6.5010900@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 24, 2007 12:28 AM, Eric Dumazet <dada1@cosmosbay.com> wrote:
> OK, but maybe for consistency, we might accept the two mechanisms.

It's not a question of the kernel interface.  The issue with all these
extensions is the userlevel interface.  Ideally no new userlevel
interface is needed.  This is the case for open() and incidentally
also for this case (through the flags parameter for recvmsg).  For
socket(), accept(), the situation is unfortunately different and we
need a new interface.

With your proposed patch, we would have to introduce another recvmsg()
interface to take advantage of the additional functionality.  This
just doesn't make any sense.  This is no contest in aesthetics.  You
first have to think about the interface presented to the programmer at
userlevel and then design the syscall interface.  This is how
MSG_CMSG_CLOEXEC came about.
