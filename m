Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbYAONqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbYAONqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbYAONp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:45:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50357 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbYAONp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:45:58 -0500
Date: Tue, 15 Jan 2008 13:42:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Message-ID: <20080115134209.7b3c2f7e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080115202711.11A6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115195022.11A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115112027.6120915b@lxorguk.ukuu.org.uk>
	<20080115202711.11A6.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> current wake up order is simply FIFO by poll(2) called.
> because the VM cannot know how much amount each process can do in free.
> the process rss and freeable memory is not proportional.

Ok this makes sense.
> 
> thus I adopt wake up one after another until restoration memory shortage.
> 
> 
> > It also appears there is no way to wait for memory shortages (processes
> > that can free memory easily) only for memory to start appearing.
> 
> poll() with never timeout don't fill your requirement?
> to be honest, maybe I don't understand your afraid yet. sorry.

My misunderstanding. There is in fact no way to wait for memory to become
available. The poll() method you provide works nicely waiting for
shortages and responding to them by freeing memory.

It would be interesting to add FASYNC support to this. Some users have
asked for a signal when memory shortage occurs (as IBM AIX provides
this). FASYNC support would allow a SIGIO to be delivered from this
device when memory shortages occurred. Poll as you have implemented is of
course the easier way for a program to monitor memory and a better
interface.

Alan
