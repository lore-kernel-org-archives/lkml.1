Return-Path: <linux-kernel-owner+w=401wt.eu-S1751829AbZLVBcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbZLVBcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZLVBcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:32:47 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:44943 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZLVBcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:32:46 -0500
Message-ID: <4B302070.5000905@oracle.com>
Date: Tue, 22 Dec 2009 09:27:12 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
CC: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: fix incorrect return value for else case
References: <1261387359-1933-1-git-send-email-wenji.huang@oracle.com> <520f0cf10912210723j1ac91183n3d7970b96b95ef23@mail.gmail.com>
In-Reply-To: <520f0cf10912210723j1ac91183n3d7970b96b95ef23@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B3021A2.017D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur wrote:
> On Mon, Dec 21, 2009 at 10:22 AM, Wenji Huang <wenji.huang@oracle.com> wrote:
>> Return original cmd instead of adding prefix.
>>
>> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
>> ---
>>  tools/perf/builtin-help.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
>> index 9f810b1..ca77df5 100644
>> --- a/tools/perf/builtin-help.c
>> +++ b/tools/perf/builtin-help.c
>> @@ -317,7 +317,7 @@ static const char *cmd_to_page(const char *perf_cmd)
>>        else if (is_perf_command(perf_cmd))
>>                return prepend("perf-", perf_cmd);
>>        else
>> -               return prepend("perf-", perf_cmd);
>> +               return perf_cmd;
>>  }
>>
>>  static void setup_man_path(void)
>> --
>> 1.5.6
> 
> Sorry - I believe we should NAK this patch.
> It would turn the following
> 
> ./perf nonsuchcmd --help
> No manual entry for perf-nonsuchcmd
> 
> into
> 
> ./perf nonsuchcmd --help
> No manual entry for nonsuchcmd
> 
> The former is correct, the name of the man page includes the prefix "perf-"
> 
> NAK
> 
> (cc-ing Frederic in case he sees it differently)
> 
Thanks. Since we think the former is better, why not make
the code compact? Like,

diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
index 9f810b1..65e2691 100644
--- a/tools/perf/builtin-help.c
+++ b/tools/perf/builtin-help.c
@@ -314,8 +314,6 @@ static const char *cmd_to_page(const char *perf_cmd)
                 return "perf";
         else if (!prefixcmp(perf_cmd, "perf"))
                 return perf_cmd;
-       else if (is_perf_command(perf_cmd))
-               return prepend("perf-", perf_cmd);
         else
                 return prepend("perf-", perf_cmd);
  }
