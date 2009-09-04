Return-Path: <linux-kernel-owner+w=401wt.eu-S934312AbZIDVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312AbZIDVjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934253AbZIDVjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:39:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934148AbZIDVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:39:12 -0400
Date: Fri, 4 Sep 2009 23:33:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, dhowells@redhat.com, roland@redhat.com,
       jmorris@namei.org, tom.horsley@att.net, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH v3] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090904213337.GA5021@redhat.com>
References: <20090904133956.GA9232@redhat.com> <20090903160514.GA23646@redhat.com> <20090903200924.E46DF47C94@magilla.sf.frob.com> <32710.1252075656@redhat.com> <20090904154947.GA17048@redhat.com> <20090904172648.GA25841@redhat.com> <20090904124230.5b7258c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904124230.5b7258c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, Andrew Morton wrote:
>
> On Fri, 4 Sep 2009 19:26:48 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Tom Horsley reports that his debugger hangs when it tries to read
> > /proc/pid_of_tracee/maps, this happens since
> >
> > 	"mm_for_maps: take ->cred_guard_mutex to fix the race with exec"
> > 	04b836cbf19e885f8366bccb2e4b0474346c02d
> >
> > commit in 2.6.31.
>
> I get a reject in binfmts.h because your kernel has `extern void
> set_binfmt' and mine has `extern int set_binfmt'.

Ah, I have exec-fix-set_binfmt-vs-sys_delete_module-race.patch from -mm
applied...

> Hopefully this patch works OK in mainline as well as in whatever kernel
> you tested against!

Yes I tried to test it ;)

> I see a Cc:stable in the mail headers, but not in the changelog.  I
> don't think the patch is applicable to -stable unless we miss 2.6.31.

-stable has the same problems but I agree, it can live without this fix.

Oleg.

