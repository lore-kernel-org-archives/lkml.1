Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbZJNRlC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbZJNRlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:41:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZJNRlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:41:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZJNRlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:41:00 -0400
Message-ID: <4AD60C78.1090908@zytor.com>
Date: Wed, 14 Oct 2009 10:38:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 09:42 AM, Luck, Tony wrote:
>>> -#define __ia64_per_cpu_var(var)	per_cpu__##var
>>> +#define __ia64_per_cpu_var(var)	var
>>
>> IA64 could completely drop the macro? Tony?
> 
> A #define that just returns its original argument untouched
> does seem to be a no-op.  So I suppose we could just fix
> the dozen or so places where it is used to just use the
> variable directly.
> 

Okay... I also don't seem to understand the more fundamental issue here,
which is:

Why are we dropping the prefix?

It may be "insufficient", but at least it stands out like a sore thumb
and makes mistakes harder.  It would be a different thing if we could
actually use the TLS ABI, but we really can't.

	-hpa
