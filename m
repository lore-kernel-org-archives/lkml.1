Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203Ab0AWTOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0AWTOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762Ab0AWTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:14:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53489 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab0AWTOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:14:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SzBF68M7yERcpvnr15DrEy38KzJFvhtZOl/uJN+3vIwamS6qPp5gL+Ue3a+z9Oqdtf
         o0CUMHumqN7cUubft4h5YKBvrNov4Fzbn7Vg8B/VuwWVlblajZQyQS8OqWOXQR2HafvF
         iJBWbtPQY4dFuE1ZEFZBCy88pqfOVtfITGjo4=
MIME-Version: 1.0
In-Reply-To: <20100123.002803.135008520.davem@davemloft.net>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org> 
	<1264230643-29434-1-git-send-email-vapier@gentoo.org> <20100123.002803.135008520.davem@davemloft.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 23 Jan 2010 14:13:35 -0500
Message-ID: <8bd0f97a1001231113r4a88120x83377572b78c1f48@mail.gmail.com>
Subject: Re: [PATCH v2] ftrace: unify arch_syscall_addr() implementations
To: David Miller <davem@davemloft.net>
Cc: vapier@gentoo.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       fweisbec@gmail.com, mingo@redhat.com, heiko.carstens@de.ibm.com,
       lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 03:28, David Miller <davem@davemloft.net> wrote:
> From: Mike Frysinger <vapier@gentoo.org>
> Date: Sat, 23 Jan 2010 02:10:43 -0500
>
>> Most implementations of arch_syscall_addr() are the same, so create a
>> default weak version in common code.  New arch ports don't have to waste
>> time copying & pasting this simple function.  The Blackfin version is
>> going to be exactly the same for example.
>>
>> The s390/sparc versions need to be different, so document why.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> You can just have the extern declaration match whatever the
> arch needs (long or int) in the generic ftrace.c code and
> then unconditionally do the (unsigned long) case.
>
> That way even s390/sparc can use the generic implementation.

asm/syscall.h is the most reasonable location to move the decls to in
asm/ ... people OK with that ?
-mike
