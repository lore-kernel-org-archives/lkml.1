Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZEGPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZEGPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZEGPBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:01:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:55769 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZEGPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:01:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Thu, 7 May 2009 17:01:50 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905071029200.3087-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905071029200.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071701.51195.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. Mai 2009 16:35:57 schrieb Alan Stern:
> On Thu, 7 May 2009, Oliver Neukum wrote:
> > On a fundamental note, thinking about this in terms of numbers of URBs
> > is strictly speaking wrong. We need to limit data in flight. For
> > efficiency we should make buffers as large as possible within that limit.
>
> But for latency you should submit URBs as soone as possible within that
> limit, which generally means small buffers.

This is true only if the device's buffer would run dry. But if no URB is
in flight, a URB should be written right away.

> How about setting the upper limit to URBs in flight based on the baud
> rate?  Faster transfers deserve more URBs, right?  Assuming some
> minimum number of bytes per URB (4? 8?), there should be enough URBs to
> fill a pipeline whose length is around 5 ms or so (interrupt latency).

Hm, you say many URBs can complete before an interrupt handler
can react?

	Regards
		Oliver

