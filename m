Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbZJIXQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbZJIXQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbZJIXQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:16:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761556AbZJIXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:16:52 -0400
Date: Fri, 9 Oct 2009 16:15:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [was: mmotm 2009-10-09-01-07 uploaded]
Message-Id: <20091009161552.fdbaf350.akpm@linux-foundation.org>
In-Reply-To: <20091009083028.61f44133.rdunlap@xenotime.net>
References: <200910090830.n998Ubvv020464@imap1.linux-foundation.org>
	<4ACF09D7.9030901@gmail.com>
	<20091009083028.61f44133.rdunlap@xenotime.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 08:30:28 -0700
Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> When CONFIG_CPU_FREQ is disabled, cpufreq_get() needs a stub.
> Used by kvm (although it looks like a bit of the kvm code could
> be omitted when CONFIG_CPU_FREQ is disabled).
> 
> arch/x86/built-in.o: In function `kvm_arch_init':
> (.text+0x10de7): undefined reference to `cpufreq_get'
>  
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Tested-by: Eric Paris <eparis@redhat.com>
> ---
>  include/linux/cpufreq.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --- linux-next-20091006.orig/include/linux/cpufreq.h
> +++ linux-next-20091006/include/linux/cpufreq.h
> @@ -291,8 +291,15 @@ struct global_attr {
>  int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
>  int cpufreq_update_policy(unsigned int cpu);
>  
> +#ifdef CONFIG_CPU_FREQ
>  /* query the current CPU frequency (in kHz). If zero, cpufreq couldn't detect it */
>  unsigned int cpufreq_get(unsigned int cpu);
> +#else
> +static inline unsigned int cpufreq_get(unsigned int cpu)
> +{
> +	return 0;
> +}
> +#endif

Thanks.  I'll merge this into mainline in the next batch I think.  It's
only needed by the KVM development tree but it's the correct thing to
do anyway and having it in minaline will simplify life for everyone.

