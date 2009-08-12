Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZHLQAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZHLQAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZHLQAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:00:48 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:47414 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZHLQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:00:47 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 12:00:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=uTV17sKlvglXOzTCfk3cAFQm93wjoES5ImMPm0TtftdxwpqWAhYzMBOSN8EUPGj05S
         WDnPzXwLhLHb7QIXc8/3UeHN9Jb/xpvmrIHJPRU0PUwtnPgz4OwgLlwV0tMNYkTqZuBH
         zfZOK/CbRi17ivD4bvl7apmQYzDLjG168TOlU=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090812153529.716542680@chello.nl>
References: <20090812153529.716542680@chello.nl>
Date: Wed, 12 Aug 2009 17:54:56 +0200
Message-ID: <7c86c4470908120854h2868695dka07ce55377bd262a@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf_counter: fix the group mess
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 5:35 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>
> With these two patches the below proglet gives:
>
> # ./test
> EVNT: 0xffffffff811c0f4c scale: nan ID: 37 CNT: 1006180 ID: 38 CNT: 1010230 ID: 39 CNT: 1010332 ID: 40 CNT: 1010420
>
> I can't seem to catch the SIGIO thing, but at least all the counters report

I think it's because you are missing this fcntl() call to get async
notification:

       ret = fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_ASYNC);
        if (ret == -1)
                err(1, "cannot set ASYNC");
