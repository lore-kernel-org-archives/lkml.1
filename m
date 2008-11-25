Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYKYUCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYKYUCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKYUCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:02:37 -0500
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:32883 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYKYUCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:02:36 -0500
Message-ID: <492C59DD.5070401@cs.columbia.edu>
Date: Tue, 25 Nov 2008 15:02:37 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] In-kernel process restart
References: <1227541175-30301-1-git-send-email-major@openvz.org>
In-Reply-To: <1227541175-30301-1-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrey Mirkin wrote:
> These patchset introduces OpenVZ kernel based restart procedure on top of
> Oren's checkpoint/restart patchset v9.
> 
> For restarting a set of processes one will need to call sys_restart() once with
> new flag CR_CTX_RSTR_IN_KERNEL. All work will be done in kernel in this case.
> 
> Small changes to image format are required to make in-kernel process creation
> more easy.
> 
> Oren, please take a look on this patchset. I've tried to port OpenVZ
> functionality on top of yours with minimal changes.
> 

Thanks, Andrey. The patch looks simple and good.

Did you look at my (user-space) process creation code ?  specifically, it
uses the task-pids array (that is saved during checkpoint) to figure out
how many children a task has to spawn and their corresponding pids.

Is there a particular reason that you chose not to use that data during
restart ?  eventually, you'll need to add the rest of it, too, to the task
data, like you did with the number of children in this patch.

Instead, since the data is available and the logic is available, we can
have each new thread call do_restart_task(), and the container init
should call do_restart_root().

What do you think ?  I can go ahead and make the changes on top of your
patch.

Oren.


