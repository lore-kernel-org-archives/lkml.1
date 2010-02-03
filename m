Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0BCRNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:13:07 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53274 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427Ab0BCRNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:13:04 -0500
Message-ID: <4B69AE88.7080705@us.ibm.com>
Date: Wed, 03 Feb 2010 09:12:40 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] trace-cmd: fix printf compile warnings
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com> <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com> <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com> <1265214665.24386.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1265214665.24386.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2010-02-03 at 17:07 +0100, John Kacur wrote:
>> On Mon, Feb 1, 2010 at 5:50 PM, Darren Hart <dvhltc@us.ibm.com> wrote:
>>> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
>>> ---
>>>  trace-read.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/trace-read.c b/trace-read.c
>>> index a04c85b..5befaba 100644
>>> --- a/trace-read.c
>>> +++ b/trace-read.c
>>> @@ -216,7 +216,7 @@ static void read_rest(void)
>>>                r = read(input_fd, buf, BUFSIZ);
>>>                if (r > 0) {
>>>                        buf[r] = 0;
>>> -                       printf(buf);
>>> +                       printf("%s", buf);
>>>                }
>>>        } while (r > 0);
>>>  }
>>> --
>>> 1.6.3.3
>>>
>> Oh! Obviously correct, thanks Darren.
> 
> Of the three patches, I think this is the only one that is correct ;-)

The other appear to depend on the guint arch specific implementation of 
the guint64 type, so the only way to fix it with a cast to ull - or to 
not use g types at all. Bleh.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
