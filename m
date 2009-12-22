Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbZLVAjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbZLVAjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZLVAjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:39:37 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45621 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZLVAje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jQHs2sw0c2hbKP/+563lb+cIkQ50C88+OEdbwtXpBu38CP4WOaWD250Pv/8D8x9hhR
         6veTn0XZZASwcfHO7zYwK5YDzSIR9rvkQwYTZuwBh2cKhbLGjvI3HB59/JL7apfwAT7d
         dbJLUL8Z4LjzUqKk+J6ucXuwmxjnAHOI3/n1Y=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu>
References: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>
	 <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu>
Date: Tue, 22 Dec 2009 01:39:31 +0100
Message-ID: <2b41c200912211639p30927d84k9253ac7c90ac0e68@mail.gmail.com>
Subject: Re: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the bad changeset:

diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 2ebd397..e7a6cca 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -22,11 +22,7 @@ SECTIONS
   _text = .;
   _stext = .;
   __init_begin = .;
-  .init.text : {
- _sinittext = .;
- INIT_TEXT
- _einittext = .;
-  }
+  INIT_TEXT_SECTION(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);

   .text      :

//richard
2009/12/22, Tim Abbott <tabbott@ksplice.com>:
> The individual chunks of that patch are all independent; could you
> determine which one of the changes causes the problem?
>
> 	-Tim Abbott
>
> On Tue, 22 Dec 2009, richard -rw- weinberger wrote:
>
>> Hi,
>>
>> CONFIG_STATIC_LINK=y is broken since 2.6.32.
>> The linux binary segfaults immediately.
>>
>> This patch introduced the regression (bisected):
>> 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80 is first bad commit
>> commit 5d150a97f9391f5bcd7ba0d59d7a11c3de3cea80
>> Author: Tim Abbott <tabbott@ksplice.com>
>> Date:   Thu Sep 24 10:36:20 2009 -0400
>>
>>     um: Clean up linker script using standard macros.
>>
>>     Signed-off-by: Tim Abbott <tabbott@ksplice.com>
>>     Cc: Jeff Dike <jdike@addtoit.com>
>>     Cc: user-mode-linux-devel@lists.sourceforge.net
>>     Acked-by: Sam Ravnborg <sam@ravnborg.org>
>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> :040000 040000 43c1b7afe756beb0dc5073195916d54ac41e7546
>> fe33dda7c1b15c61a6a65195cc6522beb25e7ba2 M      arch
>>
>> Cheers,
>> //richard
>>
>
