Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYJJK2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYJJK2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbYJJK2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:28:05 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:65136 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYJJK2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:28:03 -0400
Message-ID: <48EF2E26.3020200@fr.ibm.com>
Date: Fri, 10 Oct 2008 12:27:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] first callers of process_deny_checkpoint()
References: <20081009190405.13A253CB@kernel>	<20081009190406.1B257119@kernel>  <20081009194350.GA31214@us.ibm.com> <1223585671.11830.40.camel@nimitz>
In-Reply-To: <1223585671.11830.40.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-10-09 at 14:43 -0500, Serge E. Hallyn wrote:
>> Hmm, I don't know too much about aio, but is it possible to succeed with
>> io_getevents if we didn't first do a submit?  It looks like the contexts
>> are looked up out of current->mm, so I don't think we need this call
>> here.
>>
>> Otherwise, this is neat.
> 
> Good question.  I know nothing, either. :)
> 
> My thought was that any process *trying* to do aio stuff of any kind is
> going to be really confused if it gets checkpointed.  Or, it might try
> to submit an aio right after it checks the list of them.  I thought it
> best to be cautious and say, if you screw with aio, no checkpointing for
> you!

IMO, the right path would be to deny checkpoint if you have aio requests
pending but if you have not, aio's are not an issue for checkpoint anymore.

but that's one easy one to track ...

C.
