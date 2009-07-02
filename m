Return-Path: <linux-kernel-owner+w=401wt.eu-S1751803AbZGBTOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbZGBTOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbZGBTOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:14:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39959 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZGBTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:14:07 -0400
Date: Thu, 2 Jul 2009 14:14:10 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
Message-ID: <20090702191410.GA17823@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907020926t6305bec9t44a50cc165f6fc28@mail.gmail.com> <20090702163731.GA14267@us.ibm.com> <6599ad830907020946r42735c9es642bddf37af755ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830907020946r42735c9es642bddf37af755ed@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Thu, Jul 2, 2009 at 9:37 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> >
> >        1. the only way it won't outlive the open file is if the
> >                task opens the file, hands the open fd over a
> >                unix socket, then exits as the last task of its
> >                pidns
> 
> Right.
> 
> >        2. We don't dereference the pid_ns, so there is no actual
> >                safety issue.  So it would become a problem only
> >                if a new pidns gets created at that same address
> 
> Which is fairly likely given that pid_namespace is allocated from a
> specific cache.
> 
> Paul

The scenario as a whole is still pretty unlikely, but there's just
no reason to risk it.

-serge
