Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXGDXug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXGDXug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbXGDXu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:50:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:39851 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbXGDXu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:50:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QXDZfw0xVDH/GxQirDTew1dOU4vMMxi83QFMpAhdcSpTOySp6akWHOflJ6i8m3ShUhCwy9QC/5/n8gE6a8wG1myCAo5L/vPeWEdeyBxapkdYyijuhcFg/8gT0Qf2YPAFl/g6ZENoFMedSGZGahaoxB1YJ3tk6z41it4rOuYjKVg=
Message-ID: <9a8748490707041650s3b122007o46c8a34647b43af3@mail.gmail.com>
Date: Thu, 5 Jul 2007 01:50:27 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH] Some love to default profiler
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070704213420.GA5864@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070704213420.GA5864@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/07, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 1) Drop __KERNEL__ out of profile.h. It contains only internal kernel stuff and
>    not in exported headers list

Even if it's not in the list of exported headers, does it really hurt
to retain that extra safeguard?

> 2) Put profile.c under CONFIG_PROFILING. You enabled profiling in config, you
>    will get it.

Makes logical sense. If the user didn't enable CONFIG_PROFILING why
should she get any profiling related overhead of any kind if we can
avoid it?

> Removes conditional branch from schedule(). Code savings on my
>    usual config:
>
>            text    data     bss     dec     hex filename
>         2921871  179895  180224 3281990  321446 vmlinux         before
>         2920141  179847  180224 3280212  320d54 vmlinux         after
>         --------------------------------------------------------------
>           -1730     -48           -1778
>
Nice savings there. Not that 1.7K is huge, but it's kernel memory is
precious :-)

> 3) Make timer_hook static (hi, Adrian!)

Makes perfect sense to me.

> 4) Convert do {} while (0) into static inline functions

Seems reasonable.

> 5) minor misc stuff
>

One tiny comment below.


> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>
>  include/linux/profile.h |   78 +++++++++++++++++++++++++-----------------------
>  kernel/Makefile         |    3 +
>  kernel/profile.c        |    2 -
>  3 files changed, 44 insertions(+), 39 deletions(-)
>
[snip]
> +#define prof_on 0
> +static inline void profile_init(void)
> +{
> +}

Just to be pedantic; don't we want a blank line between functions
here, even if they are empty?

> +static inline void profile_tick(int type)
> +{
> +}
> +static inline void profile_hits(int type, void *ip, unsigned int nr_hits)
> +{
> +}
> +static inline void profile_hit(int type, void *ip)
> +{
> +}
> +static inline void profile_munmap(unsigned long addr)
> +{
> +}
> +static inline void profile_task_exit(struct task_struct *tsk)
> +{
> +}
> +static inline int profile_handoff_task(struct task_struct *tsk)
> +{
> +       return 0;
> +}
[snip]

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
