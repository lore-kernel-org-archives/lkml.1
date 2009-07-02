Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZGBN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZGBN1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZGBN1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:27:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36471 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZGBN1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:27:10 -0400
Date: Thu, 2 Jul 2009 08:26:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
Message-ID: <20090702132659.GA8051@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com> <4A4C18D5.7020806@cn.fujitsu.com> <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com> <4A4C1B33.2030002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C1B33.2030002@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizf@cn.fujitsu.com):
> Paul Menage wrote:
> > On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> >> But I guess we are going to fix the bug for 2.6.31? So is it ok to
> >> merge a new feature 'cgroup.procs' together into 2.6.31?
> >>
> > 
> > Does this bug really need to be fixed for 2.6.31? I didn't think that
> > the namespace support in mainline was robust enough yet for people to
> > use them for virtual servers in production environments.

I don't know where the bar is for 'production environments', but I'd
have to claim that pid namespaces are there...

> If so, it's ok for me. Unless someone else has objections. Serge?

Well, on the one hand it's not a horrible bug in that at least it
won't crash the kernel.  But what bugs me is that there is no
workaround for userspace, no way for an admin to know that if he
does for t in `cat /cgroup/victim/tasks`; do kill $t; done he
won't kill his mysql server.

I think that's a bad enough risk to make it worth trying to push
Li's patch.  Surely changing Ben's procs file should be pretty
trivial to rebase?

thanks,
-serge
