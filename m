Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZJLVVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZJLVVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZJLVVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:21:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:35317 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbZJLVVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:21:42 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ben Efros <ben@pc-doctor.com>, Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Oct 2009 08:19:46 +1100
Message-Id: <1255382386.2192.125.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 10:58 -0400, Alan Stern wrote:
> Except that this is wrong.  We can retry if temp_result == 
> USB_STOR_TRANSPORT_FAILURE, but we should not retry if temp_result ==
> USB_STOR_TRANSPORT_ERROR.
> 
> Alan Stern
> 
> P.S.: In case you don't already know...  TRANSPORT_FAILURE means we
> were able to communicate with the device, and it told us that it
> couldn't carry out the command.  TRANSPORT_ERROR means we weren't able
> to communicate with the device.

Ah good, I was wondering about precisely that (discriminating the errors
more intelligently). No point retrying if the device was yanked or went
totally dead.

Cheers,
Ben.


