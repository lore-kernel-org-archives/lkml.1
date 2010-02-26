Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934846Ab0BZBJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:09:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934832Ab0BZBJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:09:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SxIu9+lr3OXexX4hi/juEgU9BVLFgnj+pS0b6zKUzM4oizCb8LjUkdS34jxzWLuF2N
         kMRAVWu9du12u+9DwWXFecVR0UgWfcQ4gGvbuv9t/Bth59Ytf/DD9hG+w7KOZVNMQ6oI
         VhpDorLjxBKipq7NvVWr6mt5ieVAA8Dwf5Bic=
MIME-Version: 1.0
In-Reply-To: <1267114634.22519.0.camel@laptop>
References: <20100225154549.GA2710@darkstar> <1267114634.22519.0.camel@laptop>
Date: Fri, 26 Feb 2010 09:09:47 +0800
Message-ID: <a8e1da1002251709k3395592ct5587d49ce31d501c@mail.gmail.com>
Subject: Re: [PATCH 07/07] printk delay per multi lines
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Hans-Joachim Picht <hans@de.ibm.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 12:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-02-25 at 23:45 +0800, Dave Young wrote:
>> +               if (!atomic_read(&l))
>> +                       atomic_set(&l, printk_delay_lines);
>
> That's racy, use atomic_cmpxchg()

Will fix, thanks

>
>> +               smp_mb__before_atomic_dec();
>> +               if (atomic_dec_return(&l))
>> +                       return;
>
> What's that barrier for?

Will fix, no memory operation here

-- 
Regards
dave
