Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZGUPrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZGUPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZGUPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:47:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60770 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZGUPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:47:30 -0400
Date: Tue, 21 Jul 2009 21:17:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: containers@lists.linux-foundation.org, Zefan Li <lizf.kernel@gmail.com>,
       linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
Message-ID: <20090721154711.GZ24157@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com> <20090721111019.GV24157@balbir.in.ibm.com> <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com> <20090721120106.GW24157@balbir.in.ibm.com> <6599ad830907210834y30e7d57aj978898a300a447d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <6599ad830907210834y30e7d57aj978898a300a447d0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* menage@google.com <menage@google.com> [2009-07-21 08:34:51]:

> On Tue, Jul 21, 2009 at 5:01 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
> >
> > lock(A)
> > lock(B)
> > unlock(A)
> > unlock(B)
> >
> > Tomorrow if a unsuspecting programmer does this
> >
> > lock(A)
> > lock(B)
> > unlock(A)
> >
> > code block
> >
> > unlock(B)
> >
> >
> > What protects code block? lock B? Is that the intention?
> >
> 
> An "unsuspecting programmer" shouldn't be adding code to
> multi-threaded routines without thoroughly understanding the locking.
> 

Agreed, but why leave behind places for people to do so. There is the
consistency factor as well, see below.


> I guess there's no harm in this patch, but as Li says, it doesn't
> really change anything.
>

Well all the other places do it right in the same routine. 

-- 
	Balbir
