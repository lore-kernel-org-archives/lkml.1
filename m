Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZJXSHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZJXSHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 14:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZJXSHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 14:07:19 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:53641 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZJXSHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 14:07:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dh5uTtdZZ4/g8ZS+KdJgxzwZ2jEQ8EyfyN3K+lzdBAgnhnUlg268+crR0YOLRlUlWd
         Zo3K8hFvUPBfp4ZgA2HP3xtkXo1iw0VOVrYFTNLZtEdAR0H0X1P10OlV8JBkmkNHyQJm
         aEhJ/Kkt5YZEhRJE9b6663ASK/B+wh7swGbwk=
MIME-Version: 1.0
In-Reply-To: <4AE165A4.70706@ladisch.de>
References: <f22d86810910220629o433ee5d0u9857d1fb1f01cd6@mail.gmail.com>
	 <4AE165A4.70706@ladisch.de>
Date: Sat, 24 Oct 2009 23:37:22 +0530
Message-ID: <f22d86810910241107l21159ccdx2203e2b537b7f36@mail.gmail.com>
Subject: Re: Process id recycling and status of tasks
From: "Leonidas ." <leonidas137@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 1:43 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Leonidas . wrote:
>> 1. What would be an ideal way to check if a task is alive or dead from
>> kernel space?
>
> Get a reference to the task's pid (call get_task_pid(), or get_pid() on
> the return value of task_pid()), then later check whether pid_task()
> works.
>
> (pid_alive() is not what you want because this would require that you
> hold a reference to the task_struct.)
>
>> even though a certain pid might exist, it might have got recycled by
>> the time I check again, right?
>
> The functions above do not work with PID numbers but with struct pid
> which is a reference-counted object.  (The functions with "get" in their
> name increase the reference count, so don't forget to put_pid() when you
> no longer need it.)  See also the big comment in include/linux/pid.h.
>
>
> HTH
> Clemens
>


Yes, the comment in pid.h says it.

Was going through pid.c, what is the fundamental difference between pid_task()
and get_pid_task()? Is it correct to say that, get_pid_task() will
check whether the
task struct is stale or not and return accordingly and pid_task() will
blindly return
task_struct which might be stale?

Now my understanding is get_pid_task() should be followed by put_pid_task()
so the reference counting work as expected, but put_pid_task() is not an
exported symbol? Am I missing here something?

The obvious question which follows from above is what would be the correct
way to determine whether a process is alive or not using pid_alive()? Using
pid_task() does not seem correct and seemingly correct way looks unfeasible.


-Leo.
