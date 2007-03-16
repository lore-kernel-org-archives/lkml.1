Return-Path: <linux-kernel-owner+w=401wt.eu-S933281AbXCPLgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbXCPLgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933567AbXCPLgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:36:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44666 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbXCPLf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:35:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Herbert Poetzl <herbert@13thfloor.at>,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <20070313045100.GC8993@us.ibm.com>
	<Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
Date: Fri, 16 Mar 2007 05:32:28 -0600
In-Reply-To: <Pine.LNX.4.64.0703161300520.4188@raven.themaw.net> (Ian Kent's
	message of "Fri, 16 Mar 2007 13:04:52 +0900 (WST)")
Message-ID: <m1ird1o243.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Mon, 12 Mar 2007, sukadev@us.ibm.com wrote:
>
>> 
>> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
>> Subject: [PATCH 2/2] Replace pid_t in autofs with struct pid reference.
>> 
>> Make autofs container-friendly by caching struct pid reference rather
>> than pid_t and using pid_nr() to retreive a task's pid_t.
>> 
>> ChangeLog:
>> 	- Fix Eric Biederman's comments - Use find_get_pid() to hold a
>> 	  reference to oz_pgrp and release while unmounting; separate out
>> 	  changes to autofs and autofs4.
>
> What changes to autofs4?
> Do you intend this change to be made for autofs4 also?
> Perhaps you expected me to do them, in which case you probably should 
> ask me to do the patch.

The review history goes something like this.
- That's a big patch why are you touching autofs and autofs4 at the
  same time?
<split>
- Hmm.  That change in the autofs4 patch looks fishy.
<patch postponed until the issue was addressed>

autofs4 uses pids more extensively than autofs and so the change is
correspondingly larger.

If you would like to look at what it would take to get autofs4 to only
store values as struct pid * instead of storing pid_t that would be great.
But for the most part I this is a massive global change that those of us
pushing it are responsible for changing as fixing up as much of the code
as we can, as is usual kernel practice.

Eric
