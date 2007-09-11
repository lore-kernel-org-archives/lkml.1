Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbXIKNhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbXIKNhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597AbXIKNg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:36:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44269 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764164AbXIKNgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:36:55 -0400
Date: Tue, 11 Sep 2007 15:36:28 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Do not deprecate binary semaphore or do allow mutex in software
 interrupt contexts
Message-ID: <20070911153628.26ca02bc@laptopd505.fenrus.org>
In-Reply-To: <11531.17274.qm@web52008.mail.re2.yahoo.com>
References: <11531.17274.qm@web52008.mail.re2.yahoo.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 06:20:51 -0700 (PDT)
Matti Linnanvuori <mattilinnanvuori@yahoo.com> wrote:

Hi,

> I thought of a scenario where it seems appropriate to use a binary
> semaphore or a mutex in a software interrupt context. If a device
> cannot interrupt when some important variable changes, it can be
> polled occasionally to update e.g. LEDs to indicate status. Such
> polling can be done most efficiently in timers that are software
> interrupts. Timers are more efficient than works because they do not
> have so much context switching overhead. If the access to the
> variables of the device must be serialized, a binary semaphore or a
> mutex is a natural choice. If user-space writing to the device is
> likely to change the status, it can make sense not to poll the status
> of the device at the same time. The timer could therefore sensibly
> call mutex_trylock.

what do you do if the trylock fails?

> Therefore, it seems wrong to me to deprecate
> binary semaphores and disallow the use of mutexes in software
> interrupt contexts.

to be honest, the scenario describe really smells of broken locking, in
fact it really sounds like it wants to use spinlocks instead 

Greetings,
   Arjan van de Ven
