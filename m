Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYJ3REB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYJ3REB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYJ3RDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:03:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40385 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbYJ3RDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:03:52 -0400
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrey Mirkin <major@openvz.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       Louis Rilling <Louis.Rilling@kerlabs.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200810300902.47067.major@openvz.org>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
	 <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu>
	 <200810300902.47067.major@openvz.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 10:03:35 -0700
Message-Id: <1225386215.12673.280.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 10:02 +0400, Andrey Mirkin wrote:
> Anyway we should ask everyone what they think about user- and kernel- based 
> process creation.
> Dave, Serge, Cedric, Daniel, Louis what do you think about that?

My worry is where a single sys_restart() plus in-kernel process creation
takes us.

In practice, what do we do?  Do we single-thread the entire restore
process?  Or, do we do in-kernel process creation and have multiple
kernel threads trying to read out of different points in the checkpoint
file, trying to restore all their own states in parallel?  Does that
mean that we can't in practice restore from a fd like a pipe or a
network socket?

In the same way, if we *do* create the processes in userspace, how do we
do _that_?  Do we just fork() and sleep() until the kernel comes along
and blows our state away?  How does the kernel process doing the
restoring tell userspace how many things to fork?  How do we match these
new userspace processes up with the ones coming out of the checkpoint
process?

To me, it's just way too early to talk about this stuff.  Both
approaches have their issues, and I'm yet to see the differences
manifested in code so I can really sink my teeth into them

-- Dave

