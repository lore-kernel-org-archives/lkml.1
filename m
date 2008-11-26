Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbYKZLol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbYKZLol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 06:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYKZLob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 06:44:31 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:9847 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYKZLob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 06:44:31 -0500
From: Andrey Mirkin <major@openvz.org>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH 0/2] In-kernel process restart
Date: Wed, 26 Nov 2008 15:44:24 +0400
User-Agent: KMail/1.8.2
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1227541175-30301-1-git-send-email-major@openvz.org> <492C59DD.5070401@cs.columbia.edu>
In-Reply-To: <492C59DD.5070401@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261444.26345.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 November 2008 23:02 Oren Laadan wrote:
> Andrey Mirkin wrote:
> > These patchset introduces OpenVZ kernel based restart procedure on top of
> > Oren's checkpoint/restart patchset v9.
> >
> > For restarting a set of processes one will need to call sys_restart()
> > once with new flag CR_CTX_RSTR_IN_KERNEL. All work will be done in kernel
> > in this case.
> >
> > Small changes to image format are required to make in-kernel process
> > creation more easy.
> >
> > Oren, please take a look on this patchset. I've tried to port OpenVZ
> > functionality on top of yours with minimal changes.
>
> Thanks, Andrey. The patch looks simple and good.
>
> Did you look at my (user-space) process creation code ?  specifically, it
> uses the task-pids array (that is saved during checkpoint) to figure out
> how many children a task has to spawn and their corresponding pids.

Yes, I've take a look on mktree tool. The algorithm of process creation is 
quite clear.

> Is there a particular reason that you chose not to use that data during
> restart ?  eventually, you'll need to add the rest of it, too, to the task
> data, like you did with the number of children in this patch.

Agree, I'll rework my patchset to use already existing data.

> Instead, since the data is available and the logic is available, we can
> have each new thread call do_restart_task(), and the container init
> should call do_restart_root().
>
> What do you think ?  I can go ahead and make the changes on top of your
> patch.

I'll take a closer look on these functions and maybe we can use them for 
created threads too. But from our experience during in-kernel process 
creation and restore it is needed to perfrorm some restore procedures when 
process is inactive. That is why I think we can't reuse all existing code for 
in-kernel restart. Anyway I'll check everything once again.

Andrey
