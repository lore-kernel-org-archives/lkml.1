Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbYAaQKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbYAaQKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYAaQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:10:10 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:12232 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbYAaQKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:10:08 -0500
Message-ID: <47A1F2DB.7080600@fr.ibm.com>
Date: Thu, 31 Jan 2008 17:10:03 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kirill Korotaev <dev@sw.ru>
CC: Pierre Peiffer <pierre.peiffer@bull.net>,
       containers@lists.linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 09/15] (RFC) IPC: new kernel API to change
 an ID
References: <20080129160229.612172683@bull.net>	<20080129162000.454857358@bull.net>	<20080129210656.GB1990@martell.zuzino.mipt.ru>	<47A18E47.5050206@bull.net> <47A19AC2.7040709@sw.ru>	<47A1B78C.7050405@bull.net> <47A1C8FE.9010700@sw.ru>
In-Reply-To: <47A1C8FE.9010700@sw.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kirill !

Kirill Korotaev wrote:
> Pierre,
> 
> my point is that after you've added interface "set IPCID", you'll need more and more for checkpointing:
> - "create/setup conntrack" (otherwise connections get dropped),
> - "set task start time" (needed for Oracle checkpointing BTW),
> - "set some statistics counters (e.g. networking or taskstats)"
> - "restore inotify"
> and so on and so forth.

right. we know that we will have to handle a lot of these
and more and we will need an API for it :) so how should we 
handle it ? 

through a dedicated syscall that would be able to checkpoint 
and/or restart a process, an ipc object, an ipc namespace, a 
full container ? will it take a fd or a big binary blob ?   

I personally really liked Pavel idea's of filesystem. but we 
dropped the thread. 

that's for the user API but we will need also kernel services 
to expose (checkpoint) states and restore them. If it's too
early to talk about the user API, we could try first to refactor
the kernel internals to expose correctly what we need.  

That's what Pierre's patchset is trying to do. 

Cheers,

C.
