Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZL3WMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZL3WMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZL3WMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 17:12:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63440 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZL3WMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 17:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O9SU9CzC4aMajS0gvFnXNfEBpbbokEfn1NFcdiQvMdeY4pMcu07qoOa4sv9i/LUP0m
         jKBUesGH+X0xf21u5N0VsvdI180kDvFQ9A6aLysILvPrhFZU0RuZ+g7WlIMayvtBU9fg
         mav/TVBnbqmusDjG5DRBP6hkGwEdmxN4Djdm4=
Date: Wed, 30 Dec 2009 23:12:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       acme@redhat.com, mingo@elte.hu
Subject: Re: [PATCH] perf: fix incorrect return value for else case
Message-ID: <20091230221213.GH6322@nowhere>
References: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com> <520f0cf10912210723j1ac91183n3d7970b96b95ef23@mail.gmail.com> <4B302070.5000905@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B302070.5000905@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 22, 2009 at 09:27:12AM +0800, Wenji Huang wrote:
> John Kacur wrote:
>> On Mon, Dec 21, 2009 at 10:22 AM, Wenji Huang <wenji.huang@oracle.com> wrote:
>>> Return original cmd instead of adding prefix.
>>>
>>> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
>>> ---
>>>  tools/perf/builtin-help.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
>>> index 9f810b1..ca77df5 100644
>>> --- a/tools/perf/builtin-help.c
>>> +++ b/tools/perf/builtin-help.c
>>> @@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
>>>        else if (is_perf_command(perf_cmd))
>>>                return prepend("perf-", perf_cmd);
>>>        else
>>> -               return prepend("perf-", perf_cmd);
>>> +               return perf_cmd;
>>>  }
>>>
>>>  static void setup_man_path(void)
>>> --
>>> 1.5.6
>>
>> Sorry - I believe we should NAK this patch.
>> It would turn the following
>>
>> ./perf nonsuchcmd --help
>> No manual entry for perf-nonsuchcmd
>>
>> into
>>
>> ./perf nonsuchcmd --help
>> No manual entry for nonsuchcmd
>>
>> The former is correct, the name of the man page includes the prefix "perf-"
>>
>> NAK
>>
>> (cc-ing Frederic in case he sees it differently)


I personally don't mind.
Having either

	./perf nonsuchcmd --help
	No manual entry for perf-nonsuchcmd
or

	./perf nonsuchcmd --help
	No manual entry for nonsuchcmd

both make sense for the user.


>>
> Thanks. Since we think the former is better, why not make
> the code compact? Like,
>
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 9f810b1..65e2691 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -314,8 +314,6 @@ static const char *cmd_to_page(const char *perf_cmd)
>                 return "perf";
>         else if (!prefixcmp(perf_cmd, "perf"))
>                 return perf_cmd;
> -       else if (is_perf_command(perf_cmd))
> -               return prepend("perf-", perf_cmd);
>         else
>                 return prepend("perf-", perf_cmd);
>  }


Agreed!
Thanks.

