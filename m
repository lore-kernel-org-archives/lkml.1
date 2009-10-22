Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZJVArK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZJVArK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 20:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZJVArJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 20:47:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:33215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZJVArJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 20:47:09 -0400
Date: Wed, 21 Oct 2009 17:48:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Message-ID: <20091021174804.3885db37@infradead.org>
In-Reply-To: <1256167297.4768.14.camel@localhost.localdomain>
References: <1256167297.4768.14.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 16:21:37 -0700
john stultz <johnstul@us.ibm.com> wrote:

> 
> Taking a very raw attempt at this, I scratched out the following
> simple implementation. I'd appreciate any review or suggestions for
> improvements. I'm not at all certain the passing of the thread pid_t
> through the unsigned long is valid, for instance, or if
> same_thread_group() is the right check to make sure we only change
> siblings and not tid from other processes. So any advice on better
> approaches would be great.
> 
> +				return -EINVAL;
> +
> +			set_task_comm(tsk, comm);


you're pretty much the first now who touches ->comm from
not-the-thread-itself.... are you sure that is safe?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
