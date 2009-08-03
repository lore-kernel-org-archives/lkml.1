Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZHCShk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZHCShk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZHCShk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:37:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:43378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZHCShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:37:39 -0400
Subject: Re: [PATCH 3/2] fcntl: F_[SG]ETOWN_TID
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eranian@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090803180602.GA19719@redhat.com>
References: <1248953485.6391.41.camel@twins>
	 <20090730192040.GA9503@redhat.com> <1248984003.4164.0.camel@laptop>
	 <20090730202804.GA13675@redhat.com> <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
	 <20090801012736.GA30259@redhat.com> <1249314498.7924.133.camel@twins>
	 <20090803171619.GA17876@redhat.com> <1249321637.7924.163.camel@twins>
	 <20090803180602.GA19719@redhat.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 20:36:59 +0200
Message-Id: <1249324619.4842.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 20:06 +0200, Oleg Nesterov wrote:
> 
> As for F_XXXOWN/F_XXXWOWN_TID interaction. Another option, perhaps, is add
> F_{SET,GET}OWN_EX which accepts a use-visible
> 
>         struct f_setown_struct {
>                 int pid;                // > 0
>                 int type;               // enumerates PIDTYPE_PID, PIDTYPE_PGID, F_PIDTYPE_THREAD
>         }
> 
> pointer via arg. Instead of F_XXXOWN_TID + int who.
> 
> This way at least the users of new api can't be confused.

This would expose PIDTYPE* to userspace, and also fixes the value of
F_PIDTYPE_THREAD.

I'm not sure we want to go there (unless of course, PIDTYPE_* is already
exposed somewhere).

