Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYAUXzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYAUXzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYAUXza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:55:30 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57455 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbYAUXz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:55:29 -0500
Date: Mon, 21 Jan 2008 17:54:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [HELP]Problem with exit(0) and _exit(0) on RHEL x86
In-reply-to: <fa.YRcO5m0fsaAu8VNfQMYpdgaX5qk@ifi.uio.no>
To: Li Xiaodong <lixd@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <479530BF.10606@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.YRcO5m0fsaAu8VNfQMYpdgaX5qk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Xiaodong wrote:
> I thought the effects of exit(0) and _exit(0) should be different.
> 
> ----
> int main(void)
> {
>         int var = 0;
>         pid_t pid;
> 
>         printf("before vfork\n");
>         if ( (pid = vfork()) < 0 )
>                 printf("error\n");
>         else if ( pid == 0 )
>         {
>                 var++;
>                 exit(0);  /* Clear parent's IO */
>         }
> 
>         printf("%d\n",var);
>         return 0;
> }
> 
> ----
> 
> int main(void)
> {
>         int var = 0;
>         pid_t pid;
> 
>         printf("before vfork\n");
>         if ( (pid = vfork()) < 0 )
>                 printf("error\n");
>         else if ( pid == 0 )
>         {
>                 var++;
>                 _exit(0);  /* Do not clear parent's IO */
>         }
> 
>         printf("%d\n",var);
>         return 0;
> }
> 
> ----
> 
> But the actual results on RHEL5 x86 were beyond my ken. The outputs of the
> above two are the same. 
> 
> $./a.out
> before vfork
> 1
> 
> Could anyone help me with this? Thanks.

Why do you expect a different result? Also, calling exit from a vforked 
child is explicitly not allowed. The only things you can do are execve 
or _exit.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

