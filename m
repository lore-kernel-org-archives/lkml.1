Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbYJJQhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbYJJQhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYJJQhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:37:09 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56951 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbYJJQhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:37:08 -0400
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect
	checkpoint/restart to work
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de
In-Reply-To: <48EF144D.1050906@fr.ibm.com>
References: <20081009190405.13A253CB@kernel>
	 <1223626834.8787.8.camel@localhost.localdomain>
	 <48EF144D.1050906@fr.ibm.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 09:33:34 -0700
Message-Id: <1223656415.11830.48.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 10:37 +0200, Daniel Lezcano wrote:
> For example, you create a socket, the process becomes uncheckpointable, 
> you close (via sys_close) the socket, you have to track this close to be 
> related to the socket which made the process uncheckpointable in order 
> to make the operation reversible.

Challenging, yes.  Not quite a nightmare, though.

It's basically the same problem we have with r/o bind mounts individual
users in the kernel need to check some global state.  There are
temporary (like the duration of the syscall) and more chronic (like your
sockets) users.  The hard part is making sure that everything gets
properly balanced with the chronic ones.  But, we did manage to
accomplish that with the r/o bind mounts.  I haven't seen a bug in
*hours*! ;)

In any case, we can worry about that later.  

-- Dave

