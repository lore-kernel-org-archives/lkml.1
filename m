Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbYDRWfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbYDRWfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYDRWfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:35:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbYDRWfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:35:30 -0400
Date: Fri, 18 Apr 2008 15:34:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Introduce down_killable()
Message-Id: <20080418153455.4d0bee30.akpm@linux-foundation.org>
In-Reply-To: <200804181705.m3IH56W4007130@hera.kernel.org>
References: <200804181705.m3IH56W4007130@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:05:06 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> --- a/kernel/semaphore.c
> +++ b/kernel/semaphore.c
> @@ -34,6 +34,7 @@
>  
>  static noinline void __down(struct semaphore *sem);
>  static noinline int __down_interruptible(struct semaphore *sem);
> +static noinline int __down_killable(struct semaphore *sem);
>  static noinline void __up(struct semaphore *sem);

What is the reason for all the noinlines in this file?

Something to do with getting proper wchan output?  I guess it doesn't hurt
from a documentation POV, but did you find that it was actually necessary?

IOW: is gcc now capable of secretly inlining functions which are defined
further ahead in the compilation unit?


(did you actually "test" the wchan stuff, btw?)
