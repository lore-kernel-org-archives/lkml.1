Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZIWO5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZIWO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZIWO5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZIWO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:57:22 -0400
Message-ID: <4ABA3732.3040907@redhat.com>
Date: Wed, 23 Sep 2009 17:56:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>	 <4ABA1B75.7040900@redhat.com>  <4ABA1E3B.40800@redhat.com>	 <1253713800.7816.15.camel@marge.simson.net>  <4ABA2A0B.1010103@redhat.com>	 <1253714972.7816.23.camel@marge.simson.net>  <4ABA3321.9090503@redhat.com> <1253717548.7816.34.camel@marge.simson.net>
In-Reply-To: <1253717548.7816.34.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 05:52 PM, Mike Galbraith wrote:
>
>> The trace shows modules.dep was picked up from /lib/modules/2.6.31, so
>> if it continued that and picked up the modules from the same place,
>> everything would work.  Why does it try to pick up the modules from cwd?
>>      
> I don't know where that cwd is coming from off the top of my head.
>
> The symbol loading code reads the path stored in modules.dep, and chops
> at ':'.
>    

Well, you don't need to do anything to open a file from cwd: that's the 
default.  You need to actively prepend /lib/modules/blah to get it to 
load from the correct location.  What I don't understand is why it is 
only hitting me (esp. as it used to work).

-- 
error compiling committee.c: too many arguments to function

