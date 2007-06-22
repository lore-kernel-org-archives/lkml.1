Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbXFVNp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbXFVNp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 09:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbXFVNpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 09:45:50 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:47156 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbXFVNpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 09:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AWyDIzd2A4NMKP05aHEOecI1P+9/9Le23Tn/Rmg4iB9uJE/CuJaxJkBwJFaRFlKOY89+EyrWDUxc2CmsYsRiU6D+hTDImsIBQGL05IuVJDelQEJjyMpkIIi3Jbyv50tWgA1jn6wAep+nATTjHe7cLWg5U0Y+dMyk6vBmztPw/8E=
Message-ID: <961aa3350706220645i21ca51b6m82a5189c21fdf5c5@mail.gmail.com>
Date: Fri, 22 Jun 2007 22:45:47 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 2/6] Split out tasklets from softirq.c
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622040136.783692883@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622040014.234651401@goodmis.org>
	 <20070622040136.783692883@goodmis.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/22, Steven Rostedt <rostedt@goodmis.org>:

> +static inline void tasklet_unlock_wait(struct tasklet_struct *t)
> +{
> +       while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
> +}

BTW, can we use cpu_relax() instead of barrier() in this busy-wait loop?
