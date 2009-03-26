Return-Path: <linux-kernel-owner+w=401wt.eu-S1758688AbZCZO4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbZCZO4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbZCZO4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:56:14 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:33848 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZCZO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:56:13 -0400
Date: Thu, 26 Mar 2009 15:56:09 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, <greg@kroah.com>, <kay.sievers@vrfy.org>,
       <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
Message-ID: <20090326155609.56a662cf@gondolin>
In-Reply-To: <Pine.LNX.4.44L0.0903261005530.2945-100000@iolanthe.rowland.org>
References: <49CAF840.2030308@gmail.com>
	<Pine.LNX.4.44L0.0903261005530.2945-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 10:21:23 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> The idea is that this would come in useful both for suicidal sysfs 
> attributes and for hot-unplug events detected by an interrupt handler.

Yes; the ccw bus uses it's own workqueue, so it doesn't need
device_schedule_callback() to commit suicide. I guess other busses
could do the same.

> 
> But there's something I'm not clear on.  If hot-unplug events are
> detected by an interrupt handler, then what about hot-plug events?  
> Wouldn't they be detected by the same interrupt handler?  Obviously you
> can't register new devices in interrupt context, so there must be a
> workqueue or kernel thread involved somewhere.  Shouldn't the two types
> of events be managed by the same workqueue/thread?

They should, you want to serialize plug/unplug. You'll even want to use
the same queue for plug/unplug not detected in interrupt context.

The next question is how granular those workqueues should be. Per
subsystem? Per bus? Something else?
