Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYJJIsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYJJIsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755561AbYJJIsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:48:20 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:57035 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbYJJIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:48:18 -0400
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect
	checkpoint/restart to work
From: Greg Kurz <gkurz@fr.ibm.com>
To: Daniel Lezcano <dlezcano@fr.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, linux-kernel@vger.kernel.org
In-Reply-To: <48EF144D.1050906@fr.ibm.com>
References: <20081009190405.13A253CB@kernel>
	 <1223626834.8787.8.camel@localhost.localdomain>
	 <48EF144D.1050906@fr.ibm.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 10:47:01 +0200
Message-Id: <1223628421.8787.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 10:37 +0200, Daniel Lezcano wrote:
> I think implementing the reverse operation will be a nightmare, IMHO it 
> is safe to say we deny checkpointing for the process life-cycle either 
> if the created resource was destroyed before we initiate the checkpoint.
> 
> For example, you create a socket, the process becomes uncheckpointable, 
> you close (via sys_close) the socket, you have to track this close to be 
> related to the socket which made the process uncheckpointable in order 
> to make the operation reversible.
> 
> Let's imagine you implement this reverse operation anyway, you have a 
> process which creates a TCP connection, writes data and close the socket 
> (so you are again checkpointable), but in the namespace there is the 
> orphan socket which is not checkpointable yet and you missed this case.

That's exactly what I wanted to read... Tracking only is inherently
flawed. The valid way IMHO implies checks at checkpoint time.

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

