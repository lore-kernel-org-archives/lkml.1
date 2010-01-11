Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366Ab0AKMYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab0AKMYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352Ab0AKMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:24:01 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45240 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab0AKMX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:23:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bJCvAR4YOV+4yNHB9gbByvb/SZfXxU3GiyiKHGkqKSfnXamYywFyDz5tQOhEaYt1wO
         aBYNKbCcqvLiCq5hsR/JFPsIJFyQOyxmPFlWArdau7KQZrE919O0gJL3msBj6yWbEZW1
         F5+ywIsD0sF7xqC1Br9pTCGwpONpAtM2nS1aU=
MIME-Version: 1.0
In-Reply-To: <f22d86811001101258x3ed5d50bxdfab4abd16610156@mail.gmail.com>
References: <cf70f0211001040007s5be9f1aas7bb52928c8d50e7c@mail.gmail.com>
	 <8d6898731001042332m6b5b97b0n5515ae166f62aad2@mail.gmail.com>
	 <f22d86811001101258x3ed5d50bxdfab4abd16610156@mail.gmail.com>
Date: Mon, 11 Jan 2010 17:53:57 +0530
Message-ID: <8d6898731001110423l458a03dbif6d5a56d719b4602@mail.gmail.com>
Subject: Re: init_task belongs to "process 0" or "process 1"?
From: Nobin Mathew <nobin.mathew@gmail.com>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: Shivdas Gujare <shivdas.tech@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 2:28 AM, Leonidas . <leonidas137@gmail.com> wrote:
>> init_task is the head of doubly linked list which holds all
>> task_structs in the system. init_task is again the task_struct for
>> process 0/swapper/idle task. This process is created manually (I meant
>> to say not by copy_process() calls). Manually means they are static
>> structures defined in the code (see INIT_TASK, init_mm, init_fs etc).
>> There will be multiple idle task if there is more than 1 cpu core.
>> Idle task is the one which is scheduled if there is no other task
>> ready for scheduling.
>
> An idle task per core? So these tasks must be having different pids
> right? As per my understanding there is only 1 idle task, in that case
> on multiple cores when there is no activties on more than one cores,
> how things would work? Same task cant be stored on different cores at
> the same time right?
>
> How is this handled?

Yes there is one idle task per core and all idle task have the same pid 0.
once they are created they are directly put into per cpu runque,
runqueue has a member called idle
which is of type struct task_struct.

See
do_boot_cpu()
      |
do_fork_idle()
      |
fork_idle()

only the idle task in the first cpu core is created manually, all the
idle tasks in other cpu core is created using copy_process i.e.
copying the original idle task.

Correct if I am wrong.


Nobin.


>
> -Leo.
>
