Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbZIWSHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbZIWSHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZIWSHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:07:40 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:51774 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZIWSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=N23BE1xiqK5QP12CkF6omBMTUVJwvqkLM7YL7YM+6ctcj1iKqHjzPTste809b2KejG
         fR71qc6hzY2O9bSwlYopixYp3Yal69kCgalUnoyssSDKach3ggphGWN7PhUrjrDsGBjz
         Js6ewoECp4Oqni1dGk7+s9NGhD8JFOtIpbSsE=
Message-ID: <4ABA6400.8060901@tuffmail.co.uk>
Date: Wed, 23 Sep 2009 19:08:00 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Tim Abbott <tabbott@ksplice.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
       linux-modules@vger.kernel.org
Subject: Re: [PATCH 0/2] Use generic binary search function
References: <1253626718-18887-5-git-send-email-alan-jenkins@tuffmail.co.uk> <1253726926-5504-1-git-send-email-tabbott@ksplice.com>
In-Reply-To: <1253726926-5504-1-git-send-email-tabbott@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott wrote:
>> The builtin symbol tables are now sorted, so we can use a binary
>> search.
>>     
>
> Hi Alan,
>
> There a large number hand-coded binary searches in the kernel (run
> "git grep search | grep binary" to find many of them).  Since getting
> binary searches right is difficult, I've been meaning to submit a
> patch adding a lib/bsearch.c for some time now, so that we only have
> to get binary search right in one place.
>
> This patch series contains a generic binary search implementation as
> well as something converting your module.c patch to use it.  I haven't
> had a chance to boot-test yet,

You might want to wait.  I found some weirdness in my patches - as if my 
bsearch is backwards but the tables are also being reversed.

Whatever the problem, it endorses the idea of having one known good 
bsearch function :-).

>  but this should give you a sense of
> what this is going to look like.  To me, you take some somewhat
> complex code and replace it with some very straightforward code.
>
> This generic binary search implementation comes from Ksplice.  It has
> the same basic API as the C library bsearch() function.  Ksplice uses
> it in half a dozen places with 4 different comparison functions, and I
> think our code is substantially cleaner because of this.
>
> I don't claim that this is a perfect implementation of binary search,
> though it is reasonably well tested.  My theory is that it is about as
> good as all the hand-coded copies all over the kernel, and we can
> optimize it to perfection later.
>
> Tim Abbott (2):
>   lib: Add generic binary search function to the kernel.
>   module: use bsearch in find_symbol_in_kernel_section.
>
>  include/linux/bsearch.h |    9 ++++++++
>  kernel/module.c         |   34 +++++++++++++----------------
>  lib/Makefile            |    2 +-
>  lib/bsearch.c           |   53 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 78 insertions(+), 20 deletions(-)
>  create mode 100644 include/linux/bsearch.h
>  create mode 100644 lib/bsearch.c
>
>   

