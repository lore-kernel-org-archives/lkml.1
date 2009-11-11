Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZKKPAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZKKPAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZKKPAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:00:54 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:43264 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbZKKPAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:00:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sPD6bipcomgGf6zF4ZY8n/kRfaNaN4vcPlCvS1a19Nw/Sdov0nDA5oaSBw5nZxVoy1
         C1ZHUR7SYJL/dqjHQILr6GVa6OY/sbu/2MPtz6JENgkLMKKK1MR0a3rWuygaCFzrAflX
         nbVFHbsHy1/g/R2ws4pEWfOe5lqSBgIB4LcIU=
MIME-Version: 1.0
In-Reply-To: <200911111048.46705.rusty@rustcorp.com.au>
References: <cover.1257778258.git.andre.goddard@gmail.com> 
	<d748022cff75d9c09afc93b77cb16a683136cd13.1257778258.git.andre.goddard@gmail.com> 
	<200911111048.46705.rusty@rustcorp.com.au>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 11 Nov 2009 13:00:39 -0200
Message-ID: <b8bf37780911110700o4355aab1hd3ec3152fe2eb8c6@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] bsearch: prevent overflow when computing middle 
	comparison element
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: tabbott@ksplice.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:18 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Tue, 10 Nov 2009 02:12:31 am André Goddard Rosa wrote:
>> It's really difficult to occur in practice because the sum of the lower
>> and higher limits must overflow an int variable, but it can occur when
>> working with large arrays. We'd better safe than sorry by avoiding this
>> overflow situation when computing the middle element for comparison.
>
> I always thought the obvious answer was:
>
>        mid = start + (end - start)/2;

Hi, Rusty!

    Yes, you're right! The previous patch fixes the case where the
number of elements approach the
maximum int value (2^31 - 1 on my computer). If the number of elements
(parameter num) were an
integer amount (Java's array length case), just making those unsigned
would be enough, because
in the worst case we would have:

    (max int) * 2 < (max unsigned int)
    (2^31 - 1) * 2 < (2^32 - 1)

    But it does not fix the case where the number of elements
approaches the maximum unsigned int
value (parameter size_t num).

    So, the worst case happens when the number we search for is stored
at the highest extreme of the array.
In that case, 'start' tends toward 'end', and if 'end' is near the
maximum allowed value for a specific data type,
the overflow could still happen.

     I'm sending a fixed patch in a moment as per your suggestion.

Thank you,
André
