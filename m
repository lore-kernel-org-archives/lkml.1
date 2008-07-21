Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYGUKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYGUKiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755279AbYGUKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:38:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:41532 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYGUKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EhG9/XXl39yoCOnMWkY9zzNlaN4DPOa4TcdmlHATE3BE81n+WnyuwVwowWzaJlFRfC
         IufrsjxGRKb6OPYxtgnqKZKwHU7NFetub4Inkk3TBasupA5fGlXSc5iurdlqDt0QnDCS
         oKKJbitjQSbYSV3yUZhhxJ3PS/BHTMqOs8znY=
Message-ID: <cfd18e0f0807210338x42160e6u6d7f087719632357@mail.gmail.com>
Date: Mon, 21 Jul 2008 12:38:06 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "john stultz" <johnstul@us.ibm.com>
Subject: Re: [patch] ADJ_OFFSET_SS_READ and capabilities
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1214863660.3143.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485DF41E.9020909@gmail.com> <485E002B.5010101@gmail.com>
	 <1214863660.3143.20.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 12:07 AM, john stultz <johnstul@us.ibm.com> wrote:
>
> On Sun, 2008-06-22 at 09:32 +0200, Michael Kerrisk wrote:
>> Hi Roman, John,
>>
>> ADJ_OFFSET_SS_READ is a read-only operation.  Therefore, it seems
>> reasonable not to require any capability (as is the case when 'modes'
>> is zero.  See the patch below.  Does this change seem reasonable?
>>
>> Cheers,
>>
>> Michael
>>
>> --- linux-2.6.26-rc5/kernel/time/ntp.c        2008-06-13 11:16:51.000000000 +0200
>> +++ linux-2.6.26-rc5-p/kernel/time/ntp.c      2008-06-22 07:31:43.000000000 +0200
>> @@ -281,7 +281,8 @@
>>       int result;
>>
>>       /* In order to modify anything, you gotta be super-user! */
>> -     if (txc->modes && !capable(CAP_SYS_TIME))
>> +     if (txc->modes && txc->modes != ADJ_OFFSET_SS_READ &&
>> +         !capable(CAP_SYS_TIME))
>>               return -EPERM;
>>
>>       /* Now we validate the data before disabling interrupts */
>>
>
>
> Hey Michael,
>        This seems like an ok change, but we'd first want to fix the issue you
> pointed out earlier which would make sure adjtimex() read calls don't
> cause side effects.

John, Roman,

Are you pushing this into 2.6.27-rc1?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
