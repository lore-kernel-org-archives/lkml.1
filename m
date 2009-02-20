Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZBTXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZBTXQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZBTXQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:16:12 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:37414 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZBTXQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:16:11 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 00:20:43 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902191659020.7953-100000@iolanthe.rowland.org> <200902202305.09992.oliver@neukum.org> <d6200be20902201511w4db68e96reaa3b0901437a1d1@mail.gmail.com>
In-Reply-To: <d6200be20902201511w4db68e96reaa3b0901437a1d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902210020.47665.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 21 Februar 2009 00:11:28 schrieb Arve Hjønnevåg:
> On Fri, Feb 20, 2009 at 2:05 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Freitag 20 Februar 2009 11:46:55 schrieb Rafael J. Wysocki:
> >> On Thursday 19 February 2009, Oliver Neukum wrote:

> > With the set of runnable processes.There's always a window between
> > evaluating the current set of runnable tasks and telling the kernel to
> > sleep. IMO the most elegant solution would be a task attribute that would
> > signal the kernel that a task should not count as keeping the system busy
> > even if it is runnable and trigger the sleep in kernel space.
>
> It is not always safe to enter suspend when no tasks are runnable. For
> instance, a key event could be on a user space queue, but the code
> that reads from that queue has been paged out.

In that case you'd have a task waiting for IO. The driver should refuse
to suspend or wake up the system as IO is completed. It may be
inefficient to suspend for such a presumably short time, but it is not
a correctness issue.

	Regards
		Oliver

