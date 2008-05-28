Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYE1JOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYE1JOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 05:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYE1JO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 05:14:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:21922 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYE1JO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 05:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MW+FNF6yymfl37WQnBdZGx5U0G7yZ6zaetGnqIRQY5xPDWh5nnsVRC3uJxl1ejr8lI/I3iyXtTIHhF0upmawlxAFM4wMV85POOLwXT2SMEfuN6ALa8MFNQb947k8qdroQ2r0MXUBwzM1Q5XLc2UDzAAkP4WvEy+g3pEUEKH6E4I=
Message-ID: <3877989d0805280214y645c7e0ex91a95f1fe47a6abf@mail.gmail.com>
Date: Wed, 28 May 2008 17:14:28 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <3877989d0805270148h1b9e7972w880e380c2c4c9b09@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
	 <3877989d0805270148h1b9e7972w880e380c2c4c9b09@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some correction about the test case hang,  the ps output should looks
like the following:
13925 S+ strace -f ./test1
13926 S+ ./test1
13927 T+  /bin/bash ./test2

I'm trying upstream kdump to get more detailed data for help analysis
the scenario..
But unfortunately upstream kernel just hang when I echo c to
sysrq-trigger.  Downgrade the kernel to 2.6.22,  'echo c' doesn't
hang, but I just got "zero" dump file...
Will try F9 later... But from the symptom shouldn't we ask this
question: why  process 13927 can't wake up?  Roland,  please confirm
if ptrace_untrace is the only way to get Traced process wake up?  Back
up to caller of ptrace_untrace, maybe we can find out why my RFC patch
happen to fix the problem... Any suggestions are welcome!
--Luming
