Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYKUFqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYKUFqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 00:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYKUFq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 00:46:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:58368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbYKUFq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 00:46:27 -0500
Date: Thu, 20 Nov 2008 21:47:17 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: A question sort_main_extable()
Message-ID: <20081120214717.1a02a9af@infradead.org>
In-Reply-To: <804dabb00811202142y799fb70dxf89a1fc3514d78b1@mail.gmail.com>
References: <804dabb00811202142y799fb70dxf89a1fc3514d78b1@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 13:42:56 +0800
"Peter Teoh" <htmldeveloper@gmail.com> wrote:

> Inside start_kernel() there is a call to sort_main_extable().
> 
> void sort_extable(struct exception_table_entry *start,
>                  struct exception_table_entry *finish)
> {
>        sort(start, finish - start, sizeof(struct
> exception_table_entry), cmp_ex, NULL);
> }
> 
> With reference to
> http://tuxology.net/2008/07/08/benchmarking-boot-latency-on-x86/, I
> think it can help bootup latency (how much I got no number) if the
> sorting is done post-compilation time, instead of dynamically
> everytime the system bootup.  (perhaps at the stage of modposting,
> when all the vmlinux, kernel modules objects have been generated, so
> extracting out the exceptions strings is possible?)  Is this a
> possible optimization?

we used to do this but it was a pain and extremely fragile. Runtime
sorting makes it very robust at least.

The sort is really quick though; I've spent a lot of time on boot time
and this guy never showed up for me.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
