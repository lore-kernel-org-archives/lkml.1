Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563Ab0ALDyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0ALDyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 22:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946Ab0ALDyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 22:54:50 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:36159 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0ALDyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 22:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y21ndU37If6+aFJFVoGTElIIGPXg/HVZIXUXm/zzyCDABje5b8y3MqBfL+9TeQug0l
         scwRlrq3TpAdMKLj54TlZ8NG0lrFDG6J22ncPD+ZfUD+UTT1bZfLXAGJCVVV/EG11OH+
         mMl8PIp+g6Anrl8hGwDL21fS12xw6/C07Wzmw=
Date: Tue, 12 Jan 2010 04:54:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 25/26] kprobes: Convert to raw_spinlocks
Message-ID: <20100112035443.GI5243@nowhere>
References: <1263245216-14754-17-git-send-email-jkacur@redhat.com> <1263245216-14754-18-git-send-email-jkacur@redhat.com> <1263245216-14754-19-git-send-email-jkacur@redhat.com> <1263245216-14754-20-git-send-email-jkacur@redhat.com> <1263245216-14754-21-git-send-email-jkacur@redhat.com> <1263245216-14754-22-git-send-email-jkacur@redhat.com> <1263245216-14754-23-git-send-email-jkacur@redhat.com> <1263245216-14754-24-git-send-email-jkacur@redhat.com> <1263245216-14754-25-git-send-email-jkacur@redhat.com> <1263245216-14754-26-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263245216-14754-26-git-send-email-jkacur@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 10:26:55PM +0100, John Kacur wrote:
> Convert locks which cannot be sleeping locks in preempt-rt to raw_spinlocks.
> 
> See also dc23e836d8d25fe5aa4057d54dae2094fbc614f6
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  include/linux/kprobes.h |    2 +-
>  kernel/kprobes.c        |   34 +++++++++++++++++-----------------
>  2 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
> index 1b672f7..620df87 100644
> --- a/include/linux/kprobes.h
> +++ b/include/linux/kprobes.h
> @@ -170,7 +170,7 @@ struct kretprobe {
>  	int nmissed;
>  	size_t data_size;
>  	struct hlist_head free_instances;
> -	spinlock_t lock;
> +	raw_spinlock_t lock;
>  };


Indeed, this lock seems to be taken when a probe triggers, which
can happen in about every places/context.

Please add a comment to explain this though.

(Adding Masami in Cc).

