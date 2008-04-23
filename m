Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYDWPiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYDWPiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 11:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYDWPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 11:37:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbYDWPhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 11:37:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=f10g2kE7lP08eFJwkq5HZaoqfRpygJvVwt15kJLq2Ag3RSFDSUNiv6Vpfkf3miwVl
	hZduCoAIs1QDHXT4T+nfA==
Message-ID: <6599ad830804230837x48860632m7c41e425458ba6b3@mail.gmail.com>
Date: Wed, 23 Apr 2008 08:37:45 -0700
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: [RFC PATCH 5/5] Add a Signal Control Group Subsystem
Cc: "Matt Helsley" <matthltc@us.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Oren Laadan" <orenl@cs.columbia.edu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <480F5321.9030008@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080423142517.062433911@us.ibm.com>
	 <20080423142518.703428301@us.ibm.com> <480F5321.9030008@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 8:17 AM, Cedric Le Goater <clg@fr.ibm.com> wrote:
> Hello Matt !
>
>  > Add a signal control group subsystem that allows us to send signals to all tasks
>  > in the control group by writing the desired signal(7) number to the kill file.
>  >
>  > NOTE: We don't really need per-cgroup state, but control groups doesn't support
>  > stateless subsystems yet.
>  >
>  > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
>  > ---
>  >  include/linux/cgroup_signal.h |   28 +++++++++
>  >  include/linux/cgroup_subsys.h |    6 +
>  >  init/Kconfig                  |    6 +
>  >  kernel/Makefile               |    1
>  >  kernel/cgroup_signal.c        |  129 ++++++++++++++++++++++++++++++++++++++++++
>  >  5 files changed, 170 insertions(+)
>
>
>  I think there is a small race with new tasks entering the cgroup
>  while it's beeing killed, and a _fork ops would handle that. nop ?
>

I never saw the actual patch (what lists did it go out to?) but I
suspect that this is one of those operations that's just going to be
inherently racy, and that the API should guarantee to affect all tasks
that are members of the group for the entirety of the operation, but
with no guarantees about what happens to tasks that enter or leave in
the meantime.

Paul
