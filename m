Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbYLaIBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbYLaIBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYLaIA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:00:58 -0500
Received: from phunq.net ([64.81.85.152]:54180 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752062AbYLaIA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:00:57 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Wed, 31 Dec 2008 00:00:54 -0800
User-Agent: KMail/1.9.5
Cc: sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com>
In-Reply-To: <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812310000.55256.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008 23:34, sniper wrote:
> Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
> but I still can't debug it with gdb. Anyone gives me suggestion?

You just have to give a "cont" command a bunch of times and you will
eventually get to a command prompt.  The reason for this is, uml uses
the segfault interrupt as part of its machine simulation, and there
is no exsiting way for uml and gdb to communicate in such a way that
uml can recognize that the interrupt came from its own code and filter
it.

Jeff Dike is the expert on this, and Daniel Jacobowitz is the expert
on the gdb side.  Fixing this would be a big effort, getting two complex
systems to cooperate better, with nontrivial API issues to solve.  But
UML is such a wonderful kernel development tool that it might be worth
the effort.

In the mean time, you could just tell gdb to mask off all segfaults,
but would be kind of problematic for debugging.

Regards,

Daniel
