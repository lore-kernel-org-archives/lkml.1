Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZCSOBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZCSOBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbZCSOB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:01:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:52618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbZCSOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:01:27 -0400
Date: Thu, 19 Mar 2009 07:02:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, dipankar@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090319070221.6aca7245@infradead.org>
In-Reply-To: <200903190023.56929.dmitry.torokhov@gmail.com>
References: <20090318215812.15496a86@infradead.org>
	<200903190023.56929.dmitry.torokhov@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 00:23:56 -0700
Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> Hi Arjan,
> 
> On Wednesday 18 March 2009 21:58:12 Arjan van de Ven wrote:
> > Hi,
> >
> > the input layer does a "synchronize_rcu()" after a
> > list_add_tail_rcu(), which is costing me 1 second of boot time.....
> > And based on my understanding of the RCU concept, you only need to
> > synchronize on delete, not on addition... so I think the
> > synchronize is entirely redundant here...
> 
> 
> It is there to guarantee that once we registered the handle all
> subsequent input events will be delivered through it.


afaik rcu already guarantees that even without a synchronize;
the only reason you would need a synchronize is to guarantee that
people STOPPED using your memory. Or am I now totally misunderstanding
RCU ?
