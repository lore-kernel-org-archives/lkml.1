Return-Path: <linux-kernel-owner+w=401wt.eu-S1760544AbZCYNwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544AbZCYNwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758492AbZCYNvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:51:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:4613 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313AbZCYNvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fTuMTnolWNAk9gzFyzn64uuqiKCelonRZKYH246LKbpMAw7SUhtu6DdlFM/DEUxjli
         FwoNy8Y4TyhYQo3kl+MchOoMQYyrtdzdOB5SzDVPRRDcToMKu80WW0MS6OmJWbZPRHeK
         7sftCWxaIFtqcpFUr1qV/F2P2CsQ8NIoejHC4=
MIME-Version: 1.0
In-Reply-To: <1237968394.30175.12.camel@penberg-laptop>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
	 <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	 <009101c9ad20$1ae231c0$50a69540$@com>
	 <1237968394.30175.12.camel@penberg-laptop>
Date: Wed, 25 Mar 2009 15:51:49 +0200
X-Google-Sender-Auth: c3575f28bc5420e1
Message-ID: <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Hua Zhong <hzhong@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 01:02 -0700, Hua Zhong wrote:
>> > But those are _error handling paths_ (at least supposed to be). I
>> > wonder which call-sites are responsible for this. Can frtrace help us
>> > here?
>>
>> I am not sure why you call these error paths.
>>
>> I submitted the same patch two years ago, and you are still holding the same
>> argument.
>>
>> http://www.archivum.info/linux.kernel/2006-04/msg06042.html
>>
>> Have you used likely profiler? These are real numbers. If you insist on
>> calling them error paths then error paths are obviously the norm.

On Wed, Mar 25, 2009 at 10:06 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> I am not denying the results, I am just saying that they don't make much
> sense to me. Like I said, I would love to see the actual call-sites to
> prove my argument wrong.

OK, so according to Steven, audit_syscall_exit() is one such call-site
that shows up in the traces. I don't really understand what's going on
there but if it is sane, maybe that warrants the removal of unlikely()
from kfree(). Hmm?
