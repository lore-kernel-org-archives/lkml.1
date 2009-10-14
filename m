Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbZJNSeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbZJNSeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJNSen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:34:43 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55459 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756576AbZJNSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:34:43 -0400
Date: Wed, 14 Oct 2009 14:26:37 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Luck, Tony" <tony.luck@intel.com>, Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
In-Reply-To: <4AD60C78.1090908@zytor.com>
Message-ID: <alpine.DEB.1.10.0910141423070.9708@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
 <4AD60C78.1090908@zytor.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, H. Peter Anvin wrote:

> Okay... I also don't seem to understand the more fundamental issue here,
> which is:
>
> Why are we dropping the prefix?

That has been answered by Tejun elsewhere. It simplifies macros in many
places. Makes treatment of dynamic and static per cpu variables uniform,
solves an issue on S/390 etc.

> It may be "insufficient", but at least it stands out like a sore thumb
> and makes mistakes harder.  It would be a different thing if we could
> actually use the TLS ABI, but we really can't.

Sparse annotations will be used to detect these issues. Also generally per
cpu variables are used as parameters to per cpu functions. They only work
in the context of specifically designed macros.


