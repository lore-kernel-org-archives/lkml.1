Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0AEHdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0AEHdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924Ab0AEHct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:32:49 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:61327 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0AEHcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:32:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QuoAbd4sPnwufjHHV5jN0JX00k2wWfFvnwzxVRtLNTqkgxjhy55yGpGecix6MrgeT9
         5p+g7Z0U/uvf8ySerEk+jUkll8FnkM11px07Cm8Ftz8LJokyJAZhMDQEK1XPi0ErPZU9
         fA1FOb/uZI7X98wWWMu/HZXvyo/qB/ayTAfK4=
MIME-Version: 1.0
In-Reply-To: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com>
References: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com>
Date: Tue, 5 Jan 2010 13:02:46 +0530
Message-ID: <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
Subject: Re: init_task belongs to "process 0" or "process 1"?
From: Nobin Mathew <nobin.mathew@gmail.com>
To: Shivdas Gujare <shivdas.tech@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_task is the head of doubly linked list which holds all
task_structs in the system. init_task is again the task_struct for
process 0/swapper/idle task. This process is created manually (I meant
to say not by copy_process() calls). Manually means they are static
structures defined in the code (see INIT_TASK, init_mm, init_fs etc).
There will be multiple idle task if there is more than 1 cpu core.
Idle task is the one which is scheduled if there is no other task
ready for scheduling.

Init task is process 1 which is initially a kernel thread created from
process 0 using copy_process(), then it does an execv() (/sbin/init )
or similar one to create the normal process init.

Name given to process 0 is swapper.
.comm           = "swapper"


On Mon, Jan 4, 2010 at 1:37 PM, Shivdas Gujare <shivdas.tech@gmail.com> wrote:
> Hi all,
>
> I am trying to understand the role of linux kernel "process 0" i.e. swapper.
> I am not able to understand, where it gets started? and Does
> "init_task" from arch/arm/kernel/init_task.c belongs to "swapper" or
> "init"?
> whats the purpose of "init_task"?
>
> Thanks for your help.
>
> Thanks and Regards,
> Shivdas Gujare
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
