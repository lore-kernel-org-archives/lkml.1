Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZFNJvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZFNJvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 05:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbZFNJvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 05:51:25 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:33042 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZFNJvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 05:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=uaP3ONdHiVOM8ukJguMVcRiv+v1GNFC/4eNIT0AHDMZC9yDdpkeZjFBRwIWstvLSZu
         bMNMk2dIZ4c/AKSgHu89SCWqNc/sgVEmlziNcear76DnINayghGkAnxxDYxxYWCUnCS6
         vprobjs+tX4AK0nR0/cd2v4DOqQx1H15SSkB0=
MIME-Version: 1.0
In-Reply-To: <20090614094111.GE832@linux-sh.org>
References: <4A328DBE.2030905@oracle.com> <1244827632-24218-1-git-send-email-vapier@gentoo.org> 
	<20090614094111.GE832@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 05:51:06 -0400
Message-ID: <8bd0f97a0906140251t94d8c3fn28db16032fad408a@mail.gmail.com>
Subject: Re: [PATCH] perf_counters: start documenting HAVE_PERF_COUNTERS 
	requirements
To: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 05:41, Paul Mundt wrote:
> On Fri, Jun 12, 2009 at 01:27:12PM -0400, Mike Frysinger wrote:
>> diff --git a/tools/perf/design.txt b/tools/perf/design.txt
>> index 860e116..f71e0d2 100644
>> --- a/tools/perf/design.txt
>> +++ b/tools/perf/design.txt
>> @@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
>>  this process has created on other processes.  It only enables or
>>  disables the group leaders, not any other members in the groups.
>>
>> +
>> +Arch requirements
>> +-----------------
>> +
>> +If your architecture does not have hardware performance metrics, you can
>> +still use the generic software counters based on hrtimers for sampling.
>> +
>> +So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
>> +will need at least this:
>> +     - asm/perf_counter.h - a basic stub will suffice at first
>> +     - support for atomic64 types (and associated helper functions)
>> +     - set_perf_counter_pending() implemented
>> +
>> +If your architecture does have hardware capabilities, you can override the
>> +weak stub hw_perf_counter_init() to register hardware counters.
>
> It would be nice to see this in arch/Kconfig instead, as that tends to
> provide a centralized checklist for new features, especially when they
> are non-trivial. At least I found the arch/Kconfig bits very helpful for
> things like tracehook support, without having to grovel around
> Documentation for verbose design documents that I otherwise couldn't care
> less about.

i wouldnt mind moving all of the hidden HAVE_XXX stubs moved to
arch/Kconfig, but documentation doesnt really belong there.
especially in the case of ftrace where the document specifically for
arch porters is pages long (233 lines atm and it doesnt even cover the
really hard stuff).  the Kconfig help tip pointing to the right
document should be fine though of course.
config HAVE_XXXX
    bool
    help
      See some/place/where/the/arch/info/is/at/foo.txt

then there is no need to wade through irrelevant crap -- the Kconfig
pointed you to the right place
-mike
