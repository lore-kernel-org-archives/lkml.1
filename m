Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXJ2TLB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXJ2TLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:11:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXJ2TKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:10:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36450 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751583AbXJ2TKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:10:53 -0400
Date: Mon, 29 Oct 2007 15:10:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, <linux-usb-devel@lists.sourceforge.net>,
       Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <kkeil@suse.de>,
       <i4ldeveloper@listserv.isdn4linux.de>
Subject: Re: [linux-usb-devel] [PATCH 1/2] usb_gigaset: suspend support
In-Reply-To: <20071029185311.4C955FC04C@xenon.ts.pxnet.com>
Message-ID: <Pine.LNX.4.44L0.0710291509060.11831-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Tilman Schmidt wrote:

> From: Tilman Schmidt <tilman@imap.cc>
> 
> Add basic suspend/resume support to the usb_gigaset driver.

> @@ -117,6 +122,11 @@ static struct usb_driver gigaset_usb_dri
>  	.probe =	gigaset_probe,
>  	.disconnect =	gigaset_disconnect,
>  	.id_table =	gigaset_table,
> +	.suspend =	gigaset_suspend,
> +	.resume =	gigaset_resume,
> +	.reset_resume =	gigaset_resume,
> +	.pre_reset =	gigaset_suspend,
> +	.post_reset =	gigaset_resume,
>  };

Does this really compile?  The .pre_reset and .suspend members are 
pointers to functions with different prototypes; I don't see how you 
can assign the same function to both pointers.

Alan Stern

