Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXAZBEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXAZBEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030553AbXAZBEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:04:34 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4452 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030525AbXAZBEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:04:33 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RE: Excessive printks increase top mem usage?
Date: Thu, 25 Jan 2007 17:03:56 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEFLBCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <b681c62b0701250523w14f0d0efl78b1ab3be7693c31@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 26 Jan 2007 17:04:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 26 Jan 2007 17:04:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On 1/25/07, yogeshwar sonawane <yogyas@gmail.com> wrote:
> > Hi all,
> > I am running a user application which will just open/close my driver
> > (simple one, empty functions with only printks) infinitely.
> > A massive use of printk can slow down the system noticeably OR it can
> > affect some time calculations.
> > Apart from this, it was increasing top mem usage also. After closing
> > the application, the memory consumption was not coming down(not
> > freeing mem). Is this the expected behaviour? OR i am missing
> > something?
> >
> > Can anybody help me in guiding the reason for this? Any help/links plz.
> >
> > Thanks in advance,
> > Yogeshwar

What does "increased top mem usage" mean? You have given no reason to
suggest that there's anything unusual about this.

Here's one theory: Some program is writing these kernel messages to a file.
Because some other process might come and read that file later, the kernel
keeps copies of the file data in memory.

The kernel sees no advantage in having memory free. Free memory is memory
that's not doing any good. Better to keep data in memory that might be
useful later. We can always free the memory later if (and only if) we have
something better to do with it.

DS


