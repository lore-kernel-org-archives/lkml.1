Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbXH2Jsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbXH2Jsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 05:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbXH2JsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 05:48:25 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:62026 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXH2JsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 05:48:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rwardBPaEsLS1iWm4cQ355aRpq2qMWIN6UtiluQK7prChohafzJet01824IhlHCChpwbZGwlfLByBYj5ljGEnIWd+KVvEif8P3uBt5fcH7+VL+fykoq1BDfmavrvqa9XzFxSOuleQqFjRm+GweVHlB3Ne4DiXctdY4UbGj2xEdo=
Message-ID: <25ae38200708290248w2cdd152fpbdaa1b123de0b7ef@mail.gmail.com>
Date: Wed, 29 Aug 2007 15:18:20 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Fork Bombing Patch
Cc: "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <46CDD98F.2020208@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	 <46C4BC46.7000305@redhat.com>
	 <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	 <46C9A867.6090509@redhat.com>
	 <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
	 <m3d4xeii2z.fsf@maximus.localdomain> <46CDD98F.2020208@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
                printk_ratelimit function takes care of flooding the
syslog. due to printk_ratelimit function syslog will not be flooded
anymore. as soon as administrator gets this message, he can take
action against that user (may be block user's access on server). i
think the my fork patch is very useful and helps administrator lot.
                i would also like to mention that in some of the cases
ulimit solution wont work. in that case fork bombing takes the machine
and server needs a reboot. i am sure in that situation this printk
statement helps administrator to know what has happened.

Anand

On 8/24/07, Chris Snook <csnook@redhat.com> wrote:
> Krzysztof Halasa wrote:
> > Hi,
> >
> > "Anand Jahagirdar" <anandjigar@gmail.com> writes:
> >
> >>    I am forwarding one more improved patch which i have modified as
> >> per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
> >> i have added one more if block to check hard limit. how good it is?
> >
> > Not very, still lacks "#ifdef CONFIG_something" and the required
> > Kconfig change (or other runtime thing defaulting to "no printk").
>
> Wrapping a single printk that's unrelated to debugging in an #ifdef
> CONFIG_* or a sysctl strikes me as abuse of those configuration
> facilities.  Where would we draw the line for other patches wanting to
> do similar things?
>
> I realized that even checking the hard limit it insufficient, because
> that can be lowered (but not raised) by unprivileged processes.  If we
> can't do this unconditionally (and we can't, because the log pollution
> would be intolerable for many people) then we shouldn't do it at all.
>
> Anand -- I appreciate the effort, but I think you should reconsider
> precisely what problem you're trying to solve here.  This approach can't
> tell the difference between legitimate self-regulation of resource
> utilization and a real attack.  Worse, in the event of a real attack, it
> could be used to make it more difficult for the administrator to notice
> something much more serious than a forkbomb.
>
> I suspect that userspace might be a better place to solve this problem.
>  You could run your monitoring app with elevated or even realtime
> priority to ensure it will still function, and you have much more
> freedom in making the reporting configurable.  You can also look at much
> more data than we could ever allow in fork.c, and possibly detect
> attacks that this patch would miss if a clever attacker stayed just
> below the limit.
>
>        -- Chris
>
