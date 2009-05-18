Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZERStT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZERStT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 14:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZERStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 14:49:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58368 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751191AbZERStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 14:49:12 -0400
Date: Mon, 18 May 2009 19:50:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <Tero.Kristo@nokia.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Memory management timer optimizations for power saving
Message-ID: <20090518195010.0d0ba10b@lxorguk.ukuu.org.uk>
In-Reply-To: <1F18D6510CF0474A8C9500565A7E41A20544D91D8C@NOK-EUMSG-02.mgdnok.nokia.com>
References: <1F18D6510CF0474A8C9500565A7E41A20544D91D8C@NOK-EUMSG-02.mgdnok.nokia.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 14:40:59 +0200
<Tero.Kristo@nokia.com> wrote:

> Hi,
> 
> I've been looking at some timer optimizations for the kernel to get it to sleep as long as possible, and to allow maximum power saving in embedded ARM environment. One of the most severe timer users appears to be memory management, with reap_work and wb_timer expiring rather often (I am seeing something like one timer expiring every two seconds or so.) In the attached patch I have changed the timers to deferred type, i.e. they can be delayed until next wakeup occurs from some other source, like another timer or some peripheral I/O. Can you see any problems doing something like this? A potential issue could be that some data writeback to permanent storage gets delayed, and in case of a sudden power loss it might be lost completely.

There was an old thread where there were discussions about adding an
accuracy to timers was discussed (its relevant for virtual machines as
well where you want the timers to be handled by the hypervisor and
clustered). It certainly makes sense to add the ability to mark some
timers as ranges. Linus argued that for almost all timers you could set
an accuracy range as a fraction of the timeout value without fixing them
all up.

Another question would be whether reap_work and wb_timer could in fact be
smarter so they don't run so much but get started when really needed.

Alan
