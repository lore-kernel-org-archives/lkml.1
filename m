Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZHZQdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZHZQdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZHZQdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:33:42 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64565 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZHZQdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CM2+D3HrqYxSr8RQjh7i3zADe72xpxnlfudso8dRm2gtVmU9eGowjfCBPIoyGus8YR
         HlvSOd1joX/pMWW+i39kvqBgKhzbffD9owJIkcxd+O3hovoIlgG/a0sT8iqNwR3rBLng
         y0f+kAe77AYTAPy7iXxc9OUeIbQ+8Y+lDnAwA=
MIME-Version: 1.0
In-Reply-To: <200908262002.06209@zigzag.lvk.cs.msu.su>
References: <200908262002.06209@zigzag.lvk.cs.msu.su>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Wed, 26 Aug 2009 12:32:51 -0400
Message-ID: <3e8340490908260932k3872d92am4a55593386c0cff@mail.gmail.com>
Subject: Re: Suspend one thread and resume another in one system call ?
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: linux-kernel@vger.kernel.org, Stas Bezzubtsev <stas@lvk.cs.msu.su>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 12:02 PM, Nikita V. Youshchenko<yoush@cs.msu.su> wrote:
> Hello.
>
> Consider a situation when:
> - there is a set of threads,
> - only one of those should be allowed to work at a time,
> - there are "switch moments" when one thread should suspend, and other
> (known) resume.
>
> "Classic" solutions like have each thread sleeping on a semaphore, and
> making switch operation "sem_post(next_sem); sem_wait(my_sem)" cause two
> syscalls per switch.
>
> Could anyone suggest a solution with only one kernel entry per switch -
> running thread enters kernel and is de-scheduled, new thread resumes and
> leaves kernel?
>
> Nikita
>
> P.S.
> Since there are other threads in the same application working in the
> parallel with the mentioned "exclusive set", user-space solutions like
> libpth are not interesting.

If these threads are truly exclusive, just use ucontext.h's
setcontext() to switch threads in userspace.
