Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXI3AcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXI3AcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 20:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbXI3AcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 20:32:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:1986 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbXI3AcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 20:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=E7fOWQIV0MpFTl6BkDOxWCeCZ7nfjJS/t0uu4XVs3LdeIPaGfD7PhhlZ31mRmOVIGRlosQMxTI7ayjN9aAe5CNDLi7ae7WHcTgAgalsHNUqthecY9BDSpcavhf63iEuqgYDMhPwCMHFeJq4g6iZbb9RWm9fgT1fN8Ues3Z2/qeM=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: F_DUPFD_CLOEXEC implementation
Date: Sun, 30 Sep 2007 01:31:49 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
In-Reply-To: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709300131.49320.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulrich,

On Friday 28 September 2007 18:34, Ulrich Drepper wrote:
> One more small change to extend the availability of creation of
> file descriptors with FD_CLOEXEC set.  Adding a new command to
> fcntl() requires no new system call and the overall impact on
> code size if minimal.

Tangential question: do you have any idea how userspace can
safely do nonblocking read or write on a potentially-shared fd?

IIUC, currently it cannot be done without races:

old_flags = fcntl(fd, F_GETFL);
...other process may change flags!...
fcntl(fd, F_SETFL, old_flags | O_NONBLOCK);
read(fd, ...)
...other process may see flags changed under its feet!...
fcntl(fd, F_SETFL, old_flags);

Can this be fixed?
--
vda
