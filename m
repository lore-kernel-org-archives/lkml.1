Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXJ3VCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXJ3VCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbXJ3VCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:02:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753381AbXJ3VCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:02:16 -0400
Date: Tue, 30 Oct 2007 14:01:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, hjlipp@web.de, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: Re: [PATCH 1/2] usb_gigaset: suspend support [v2]
Message-Id: <20071030140124.984aba58.akpm@linux-foundation.org>
In-Reply-To: <20071029214131.70EABFC043@xenon.ts.pxnet.com>
References: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>
	<20071029214131.70EABFC043@xenon.ts.pxnet.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 22:41:30 +0100 (CET)
Tilman Schmidt <tilman@imap.cc> wrote:

> From: Tilman Schmidt <tilman@imap.cc>
> 
> Add basic suspend/resume support to the usb_gigaset driver.
> (Corrected version.)
> 

You're not a big fan of checkpatch, I see.

> +static int gigaset_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct cardstate *cs;
> +	struct usb_cardstate *ucs;
> +
> +	if ((cs = usb_get_intfdata(intf)) == NULL ||
> +	    (ucs = cs->hw.usb) == NULL) {
> +		err("%s: no cardstate", __func__);
> +		return -EFAULT;
> +	}

Is the above reeeeeely needed?  I bet it never happens.

> +static int gigaset_resume(struct usb_interface *intf)
> +{
> +	struct cardstate *cs;
> +	struct usb_cardstate *ucs;
> +	int rc;
> +
> +	if ((cs = usb_get_intfdata(intf)) == NULL ||
> +	    (ucs = cs->hw.usb) == NULL) {
> +		err("%s: no cardstate", __func__);
> +		return -EFAULT;
> +	}

ditto.
