Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbZHCTHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbZHCTHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZHCTHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:07:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43654 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZHCTHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:07:03 -0400
Date: Mon, 3 Aug 2009 21:02:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Subject: Re: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
Message-ID: <20090803190231.GA22313@redhat.com>
References: <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins> <20090731141122.a1939712.akpm@linux-foundation.org> <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins> <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins> <20090803180602.GA19719@redhat.com> <1249324619.4842.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249324619.4842.1.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Peter Zijlstra wrote:
>
> On Mon, 2009-08-03 at 20:06 +0200, Oleg Nesterov wrote:
> >
> > As for F_XXXOWN/F_XXXWOWN_TID interaction. Another option, perhaps, is add
> > F_{SET,GET}OWN_EX which accepts a use-visible
> >
> >         struct f_setown_struct {
> >                 int pid;                // > 0
> >                 int type;               // enumerates PIDTYPE_PID, PIDTYPE_PGID, F_PIDTYPE_THREAD
> >         }
> >
> > pointer via arg. Instead of F_XXXOWN_TID + int who.
> >
> > This way at least the users of new api can't be confused.
>
> This would expose PIDTYPE* to userspace,

No, no, we should not export them of course.

f_setown_struct->type could be 0,1,2 (or whatever), fcntl() maps them
to fown_struct->enum_type or ->enum_type + ->task_only.


To clarify, I am not really sure this interface is better. Just for
discussion. Because it will be very painful to change this api later.
It is better to at least consider all options now.

Oleg.

