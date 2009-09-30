Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbZI3Gey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbZI3Gey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZI3Gex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:34:53 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49527 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751120AbZI3Gex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:34:53 -0400
Message-ID: <4AC2FBBA.9070307@gandalf.sssup.it>
Date: Wed, 30 Sep 2009 08:33:30 +0200
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Johan Hovold <jhovold@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost>	<200909242103.48562.oliver@neukum.org>	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>	<20090924211459.GB27963@localhost>	<4ABD020B.4040901@gandalf.sssup.it>	<20090929145514.GF2152@localhost> <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> As it stands today ftdi_sio does indeed call tty_flip_buffer_push from
>> interrupt context with low_latency set and that is obviously incorrect,
>> right?
>>     
>
> It seems to do it from a work queue - or did I miss a case ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   
  usb_fill_bulk_urb(port->read_urb, dev,
                        usb_rcvbulkpipe(dev, port->bulk_in_endpointAddress),
                        port->read_urb->transfer_buffer,
                                port->read_urb->transfer_buffer_length,
                        ftdi_read_bulk_callback, port);

  (can be call in the interrupt context)
  ftdi_read_bulk_callback--->
                            ftdi_process_read-->      
                                                tty_flip_buffer_push(tty);
                                               
                                               

Michael
