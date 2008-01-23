Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYAWTCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYAWTCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYAWTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:01:57 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:50304 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYAWTB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=t5zTy3QdBflVpnQBZJJTiZuLYiwWh0qYb56yqhJ4dhStxdUDLQJBj9L5VGvpOQHfLeVYtCIgjJqBtNjkh2txK/XCkllPZEwn7AZvn03oNtk5DvFf4UpFbLOedmzNUNoloMPTYmL6gaxFesCTQx9nbnGbSIXOnDLzDH+gj+fsD8U=
Message-ID: <14344f930801231101w3906aeaey88034e0fa8fa3f36@mail.gmail.com>
Date: Thu, 24 Jan 2008 03:01:53 +0800
From: "Wang Nan" <wn.at.lkml@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Can any one tell me why cond_resched in do_select?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, everyone.
I have a question regarding to select system call's code. In
do_select() function, after check each fd in the set, do_select() call
cond_resched(). That line, according to my view, is to reduce the
system freeze time when do the busy querying. But before the call,
when entering into the big loop, do_select call
set_current_state(TASK_INTERRUPTIBLE). Then, if the reschedule really
taken up, the current process will not return unless it catch a
signal, or one of already registered fd send an event.
I've tried in UML. If I replace the cond_resched() into schedule(),
when sys_select() called, the process halt just like I've said.
I don't think there is a bug because this code exist so long time and
no really bad thing happened. I just want to know that, since no
schedule() allowed here, can we delete the useless line?
Thank you.
