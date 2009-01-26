Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZAZQi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZAZQi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbZAZQiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:38:50 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:22446 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZAZQit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:38:49 -0500
Message-ID: <497DE701.5050005@oracle.com>
Date: Mon, 26 Jan 2009 08:38:25 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Teemu Likonen <tlikonen@iki.fi>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] Documentation: update CodingStyle tips for Emacs users
References: <1232299115-8130-1-git-send-email-tlikonen@iki.fi> <87priaumal.fsf@iki.fi>
In-Reply-To: <87priaumal.fsf@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.497DE709.0056:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teemu Likonen wrote:
> Teemu Likonen (2009-01-18 19:18 +0200) wrote:
> 
>> With the previous Emacs tips example the kernel style was made available
>> for files in the kernel-tree only. This patch updates the tip to add
>> separate cc-mode indent style; it makes the kernel style easily
>> available for any filetype mode that is managed by the Emacs cc-mode.
>>
>> We also fix the filename regexp in the example: Elisp function
>> buffer-file-name returns full pathname, not a path relative to user's
>> home directory. Hence a tilde (~) can't be used to refer to home
>> directory (as the previous code did).
>>
>> Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
>> ---
>>  Documentation/CodingStyle |   19 +++++++++++++------
>>  1 files changed, 13 insertions(+), 6 deletions(-)
> 
> 
> Exactly what I expected: nobody pays any attention. :-) Well, it's not a
> problem, I'm not even a kernel coder. I just happen to think that this
> patch introduces the right way to configure Emacs for kernel coding
> style. Adding a custom style like this ("linux-tabs-only") makes it much
> easier to switch between different indent styles and also to use the
> kernel style elsewhere.
> 
> So, I'll just ping the lists and maintainers this one more time to see
> if someone is interested. Here's my original message:
> 
>     http://article.gmane.org/gmane.linux.documentation/442
> 

OK, I see it.  I'm not an emacs user and I have no idea how correct
the patch is.

There is another emacs CodingStyle patch from Dan Carpenter that
expands the "~" part of the filename to the user directory:
see http://lkml.org/lkml/2009/1/21/62

so I would be tempted to merge/apply both patches.

Any other comments on these patches?

> 
>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>> index 1875e50..2cda242 100644
>> --- a/Documentation/CodingStyle
>> +++ b/Documentation/CodingStyle
>> @@ -483,20 +483,27 @@ values.  To do the latter, you can stick the following in your .emacs file:
>>      (* (max steps 1)
>>         c-basic-offset)))
>>  
>> +(add-hook 'c-mode-common-hook
>> +          (lambda ()
>> +            ;; Add kernel style
>> +            (c-add-style
>> +             "linux-tabs-only"
>> +             '("linux" (c-offsets-alist
>> +                        (arglist-cont-nonempty
>> +                         c-lineup-gcc-asm-reg
>> +                         c-lineup-arglist-tabs-only))))))
>> +
>>  (add-hook 'c-mode-hook
>>            (lambda ()
>>              (let ((filename (buffer-file-name)))
>>                ;; Enable kernel mode for the appropriate files
>>                (when (and filename
>> -                         (string-match "~/src/linux-trees" filename))
>> +                         (string-match "src/linux-trees" filename))
>>                  (setq indent-tabs-mode t)
>> -                (c-set-style "linux")
>> -                (c-set-offset 'arglist-cont-nonempty
>> -                              '(c-lineup-gcc-asm-reg
>> -                                c-lineup-arglist-tabs-only))))))
>> +                (c-set-style "linux-tabs-only")))))
>>  
>>  This will make emacs go better with the kernel coding style for C
>> -files below ~/src/linux-trees.
>> +files which pathname matches src/linux-trees.
>>  
>>  But even if you fail in getting emacs to do sane formatting, not
>>  everything is lost: use "indent".
>> -- 

Thanks.
-- 
~Randy
