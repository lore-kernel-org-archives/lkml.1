Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZEFL55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZEFL55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZEFL5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:57:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:65529 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbZEFL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:57:45 -0400
Message-ID: <4A017B2B.1050906@windriver.com>
Date: Wed, 06 May 2009 06:57:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: greg@kroah.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] usb_debug: implement multi urb write
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <200905060916.56384.oliver@neukum.org>
In-Reply-To: <200905060916.56384.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 11:57:22.0878 (UTC) FILETIME=[D0D7F5E0:01C9CE41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 6. Mai 2009 04:00:01 schrieb Jason Wessel:
>
> in static void usb_debug_write_bulk_callback(struct urb *urb)
>   
>> +       if (status) {
>> +               dbg("nonzero write bulk status received: %d", status);
>> +               return;
>> +       }
>>     
>
> [..]
>   
>> +       spin_lock_irqsave(&priv->tx_lock, flags);
>> +       --priv->tx_outstanding_urbs;
>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
>>     
>
> That's a clear bug. If a URB finishes, you must decrease the counter, always
> and without exception, even if status indicates an error.
>
>   
Thanks Oliver,

I would agree with you on that.  It also means that the ftdi_sio.c
driver has the same bug, because that is where it was derived from.  You
led me to see another flaw upon further inspection in that the usb_debug
driver must also implement the chars_in_buffer() call back because the
generic serial code will cause an oops with a null pointer dereference
of the write_urb.

Cheers,
Jason.

