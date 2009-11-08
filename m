Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZKHPJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZKHPJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZKHPJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:09:31 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48648 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZKHPJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:09:30 -0500
Date: Sun, 8 Nov 2009 09:09:35 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com
Subject: Re: [v11][PATCH 9/9] Document clone_with_pids() syscall
Message-ID: <20091108150935.GA14991@us.ibm.com>
References: <20091105053053.GA11289@us.ibm.com> <20091105054204.GI16142@us.ibm.com> <20091106183936.GA32531@us.ibm.com> <20091106201814.GA26614@count0.beaverton.ibm.com> <20091106214529.GB26614@count0.beaverton.ibm.com> <20091107022612.GA18039@suka> <4AF5ECFD.3000509@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF5ECFD.3000509@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> Sukadev Bhattiprolu wrote:
> > Matt Helsley [matthltc@us.ibm.com] wrote:
> > | > If userspace passes an array with n pids and there are k namespace levels
> > | > then clone_with_pids() makes sure that the kernel sees a pid array like:
> > | > 
> > | > index	  0     ... k - (n + 1)        ...          k - 1
> > | > 	+-----------------------+-------------------------+
> > | > pid_t	| 0 ..................0 | <copied from userspace> |
> > | > 	+-----------------------+-------------------------+
> > | 
> > | (diagram assumes n != k. If n == k then pids[0] is the pid desired
> > | in the initial namespace..)
> > 
> > True.
> > 
> > Also I was not sure if we should prevent choosing pids in ancestor containers.
> > since a process is not even supposed to know of ancestor namespaces. Is there
> > a need for choosing pids in those namespaces.

Yes, that is necessary.

> > | I don't know if it makes more sense to change clone_with_pids() or have
> > | [e]glibc wrappers swap the array contents.
> 
> I prefer to decide now on an order and stick to it in the kernel and
> in glibc.

Agreed!

I'd forgotten that, as Matt said, we can just specify pids to the depth
that we want, so I guess the current order is fine.

-serge
