Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYC0XN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYC0XN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYC0XNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:13:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:23517 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbYC0XNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s2vLqohu8uW5nIKIYbbP604X/Vzc55clJNOeEHcwavfFVjVWM6gYJX5X2gJWaPI4c3UVqlQsgtHuz/+oTV6yvEsJcz88XEK4oeLuEx40QpsNv6u60gcon4Zp1J6iUg8sAtcFkZTinuB4bD9bP32wWYHdrxiaHZhK/732ik6Z4BM=
Message-ID: <19f34abd0803271613vc6d6e9ic0491643eb25a3e8@mail.gmail.com>
Date: Fri, 28 Mar 2008 00:13:48 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [RFC] mmiotrace full patch, preview 2
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Pavel Roskin" <proski@gnu.org>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20080309164050.2194461e@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I may of course be wrong, but... Shouldn't the post_kmmio_handler(),
called from the die notifier chain, check for the DR_STEP condition?
This makes sure that the function is not called in the cases where the
source of the debug exception was not a single-stepping event. Though
I guess you'll also have other checks in place to notice that the
interrupt was not the one you were expecting. I guess a little extra
safety won't hurt though?

On Sun, Mar 9, 2008 at 3:40 PM, Pekka Paalanen <pq@iki.fi> wrote:
>  +/*
>  + * Interrupts are disabled on entry as trap1 is an interrupt gate
>  + * and they remain disabled thorough out this function.
>  + * This must always get called as the pair to kmmio_handler().
>  + */
>  +static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
>  +{
>  +       int ret = 0;
>  +       struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);

if (!(condition & DR_STEP))
    return;


Vegard
