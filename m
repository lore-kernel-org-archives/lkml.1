Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZEGOuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZEGOuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbZEGOtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:49:43 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47253 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbZEGOtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:49:41 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force writes
Date: Thu, 7 May 2009 16:49:45 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0905071004550.3087-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0905071004550.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905071649.46566.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. Mai 2009 16:27:12 schrieb Alan Stern:
> A more interesting question is whether to deallocate URBs as they
> complete or to reuse them.  A simple approach (which Oliver no doubt
> has already considered) is:
>
>         write_complete(urb):
>                 if (write_urb->transfer_length > 0)
>                         submit(write_urb);
>                         write_urb = urb;
>                 else
>                         urb_free(urb);

It seems to me that if I don't know the true speed of a device I should
always keep two URBs in flight. That is if we decide that the generic
implementation needs to be trimmed for extreme performance.

Two URBs ensure that the finishing of one URB can trigger new data
and an URB is still ready to fill the gap. While two URBs are in flight
the driver should concentrate on filling large buffers. If we want to get
fancy we'd even consider interrupt mitigation here.

Will the tty layer make large writes if it can? I always assumed that
the use case that cares about performances is ppp and will deliver
network packets if it has enough write room. Is that always true?

	Regards
		Oliver

