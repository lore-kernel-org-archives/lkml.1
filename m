Return-Path: <linux-kernel-owner+w=401wt.eu-S935019AbZJOI6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019AbZJOI6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934171AbZJOI6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:58:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:45710 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933197AbZJOI6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:58:41 -0400
Message-ID: <4AD6E3EC.8080901@kernel.org>
Date: Thu, 15 Oct 2009 17:57:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com> <4AD60C78.1090908@zytor.com>
In-Reply-To: <4AD60C78.1090908@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 15 Oct 2009 08:57:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin wrote:
> Okay... I also don't seem to understand the more fundamental issue here,
> which is:
> 
> Why are we dropping the prefix?
> 
> It may be "insufficient", but at least it stands out like a sore thumb
> and makes mistakes harder.  It would be a different thing if we could
> actually use the TLS ABI, but we really can't.

The reason for actively removing the prefix is because it forces us to
have two different accessors for static and dynamic ones which is made
worse by any accessor which will accept dynamic ones will accept
anything (static ones enclosed by per_cpu_var(), dynamic ones, plain
wrong random value).  Also, wide spread use of per_cpu_var() in
generic code will basically circumvent any meaningful protection the
prefix provided.

Thanks.

-- 
tejun
