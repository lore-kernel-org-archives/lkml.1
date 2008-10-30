Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYJ3Sda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYJ3Sda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYJ3SdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:33:21 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:49452 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYJ3SdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:33:21 -0400
Message-ID: <4909FDD3.5090806@cs.columbia.edu>
Date: Thu, 30 Oct 2008 14:32:51 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: Andrey Mirkin <major@openvz.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based	checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org> <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu> <200810300902.47067.major@openvz.org> <20081030114747.GL15171@hawkmoon.kerlabs.com> <4909F2B5.7040907@cs.columbia.edu> <20081030181418.GO15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081030181418.GO15171@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Thu, Oct 30, 2008 at 01:45:25PM -0400, Oren Laadan wrote:
>>
>> Louis Rilling wrote:
>>> In Kerrighed this is kernel-based, and will remain kernel-based because we
>>> checkpoint a distributed task tree, and want to restart it as mush as possible
>>> with the same distribution. The distributed protocol used for restart is
>>> currently too fragile and complex to rely on customized user-space
>>> implementations. That said, if someone brings very good arguments in favor of
>>> userspace implementations, we might consider changing this.
>> Zap also has distributed checkpoint which does not require strict
>> kernel-side ordering. Do you need that because you do SSI ?
> 
> Yes. Tasks from different nodes have parent-children, session leader, etc.
> relationships, and the distributed management of struct pid lifecycle is a bit
> touchy too. By the way, splitting the checkpoint image in one file for each task
> helps us a lot to make restart parallel, because it is more efficient for the file
> system to handle parallel reads of different files from different nodes than
> parallel reads on a single file descriptor from different nodes.

You can also make parallel restart work with the single stream, without
much effort. Particularly if you store everything on the file system.

In both cases, the limiting factor is shared resources - where one task
cannot proceed with checkpoint because it waits for another task to first
(re)create that resource.

[...]

Oren.

