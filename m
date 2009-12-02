Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZLBAWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZLBAWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZLBAWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:22:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58234 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754629AbZLBAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:22:16 -0500
Date: Wed, 2 Dec 2009 00:24:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: General kernel question about waiting for events
Message-ID: <20091202002424.1e430662@lxorguk.ukuu.org.uk>
In-Reply-To: <1259712620.23837.22.camel@maxim-laptop>
References: <1259712620.23837.22.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In that case, wrapped in different packages, it always ends with
> following loop:
> 
> while( event == false )
> schedule();

No. If it were to do that then real time processes could spin eating the
CPU forever.

There is a difference between rescheduling and sleeping for an event.
Sleeping for an event (ie on a waitqueue) means that you will not be
woken until the wait queue is woken (or certain other things like signals
if interruptible). Rescheduling gives the CPU to someone else if anyone
wants it.

In short the different task states that are set are the important bit to
look at to understand this further.
