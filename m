Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYLKEXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYLKEXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 23:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbYLKEXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 23:23:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:31449 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYLKEXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 23:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=X36AzatUkrLeRJy+59tXiNrhlR6pDlnGJmfAhng5Jtq/ixbNcpq4/s9MzbOn/jYSS/
         uZSaVY9TqKZ93aFdIiIf5Z5yJKt3PIVcKeXBJaXcs0MU2LbMz1zd+Ns4D5tYU3+ncLkx
         8ypl1PMfmGBgZnbhwWDtKXZypQasT+awrfFvk=
Message-ID: <9cde8bff0812102023v60ce265bk394c420a29100b92@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:23:36 +0900
From: "Nguyen Anh Quynh" <aquynh@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix calls to request_module()
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       "Kuniyasu Suzaki" <k.suzaki@aist.go.jp>
In-Reply-To: <20081210201455.0c611484.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	 <20081211040118.GK28946@ZenIV.linux.org.uk>
	 <20081210201455.0c611484.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 1:14 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Dec 2008 04:01:18 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
>> On Thu, Dec 11, 2008 at 12:35:21PM +0900, Nguyen Anh Quynh wrote:
>> > Hi,
>> >
>> > The request_module() function should always have the 1st param as a
>> > format argument. So for example, request_module("i2c-powermac") should
>> > be called as request_module("%s", "i2c-powermac"). Otherwise, new gcc
>> > like gcc 4.3.2 on Ubuntu 8.10 would spit out a lot of warnings. This
>> > patch fixes them all in linus-git tree.
>>
>> ... and it doesn't address the underlying problems at all.  A string literal
>> without a single % in it is a perfectly sane and valid format.  _Why_ are
>> we getting these warning?
>
> extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
>

Sorry that after the mail of Viro, I checked again by recover a code
and recompile, but got no warning. But actually that code should not
be compiled at all.

So I checked again by fixing the code that should be compiled
(sound/core/sound.c), and can confirm that without the patch we got
warning like below:

sound/core/sound.c: In function 'snd_request_other':
sound/core/sound.c:91: warning: format not a string literal and no
format arguments

And with the patch, the warnings are all gone.

So Andrew, please consider taking the patch.

Thanks,
Quynh
