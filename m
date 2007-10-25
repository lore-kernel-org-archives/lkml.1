Return-Path: <linux-kernel-owner+w=401wt.eu-S1762325AbXJYQr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325AbXJYQr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759768AbXJYQin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:38:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761332AbXJYQil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:38:41 -0400
Date: Thu, 25 Oct 2007 09:38:08 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: vitalivanov@gmail.com, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au,
       zaitcev@redhat.com
Subject: Re: USB: FIx locks and urb->status in adutux
Message-Id: <20071025093808.16e730e7.zaitcev@redhat.com>
In-Reply-To: <200710251403.48688.oliver@neukum.org>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	<1193234987.13750.21.camel@dell1.softservecom.com>
	<20071024202555.4f1cd215.zaitcev@redhat.com>
	<200710251403.48688.oliver@neukum.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007 14:03:48 +0200, Oliver Neukum <oliver@neukum.org> wrote:

> Am Donnerstag 25 Oktober 2007 schrieb Pete Zaitcev:
> > +                       if (signal_pending(current)) {
> >                                 dbg(1," %s : interrupted", __FUNCTION__);
> > +                               set_current_state(TASK_RUNNING);
> >                                 retval = -EINTR;
> > -                               goto exit;
> > +                               goto exit_onqueue;
> 
> Are you sure you cannot have written any data here?

I noticed that myself, but this is what the old driver did.

-- Pete
