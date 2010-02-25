Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0BYEJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:09:10 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65341 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0BYEJJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=euoEzEgr7r7roisJSaR7AU1v5tDEHIERy/UbT+l0m+WOC5bfGoVlJ1WHOL/G4K5OnO
         M7iDL0PqIJTsFmVIdLbNAJC0V3kzITa6NVipHqWnJyUVL4I8tY1X/U4urz2a3uLjL6Wn
         iRE23LFRXThzt70yekwEnyg4H8D6A7YIhBWCU=
MIME-Version: 1.0
In-Reply-To: <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
	 <a3a62a6cd7cc0ba011949396a1f2c7f9c32aa4b9.1266907496.git.andre.goddard@gmail.com>
	 <2375c9f91002241935k56dff805q57582d998b660889@mail.gmail.com>
Date: Thu, 25 Feb 2010 12:00:56 +0800
Message-ID: <7b6bb4a51002242000x49f0b3bdncb40912bf18f90bb@mail.gmail.com>
Subject: Re: [PATCH 6/6] mqueue: fix mq_open() file descriptor leak on 
	user-space processes
From: Xiaotian Feng <xtfeng@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/2/25 Américo Wang <xiyou.wangcong@gmail.com>:
> On Tue, Feb 23, 2010 at 3:04 PM, André Goddard Rosa
> <andre.goddard@gmail.com> wrote:
>> It can be triggered by the following test program:
>>
>
> <snip>
>
>>
>> When not running valgrind, user-space program segfaults trying to execute
>> strerror(errno). With valgrind, it executes successfully and prints the
>> 5 open files: stdin, stdout, stderr, pipe[0] and pipe[1].
>>
>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>> ---
>
> The code has more than just this problem, could you please try
> my patch below?
>
> Thanks.
>
> ---------------------------->
>
> Clean up the failure path of sys_mq_open().
>
> Reorder the goto labels;
> Rename 'upsem' to 'upunlock';
> Remove some unused labels;
> Fix some wrong goto path.
>

I think it's wrong to move dput after mntput

> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
> ---
>
