Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbZIYRsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbZIYRsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZIYRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:47:59 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54429 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbZIYRr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:47:58 -0400
Message-ID: <4ABD020B.4040901@gandalf.sssup.it>
Date: Fri, 25 Sep 2009 19:46:51 +0200
From: Michael Trimarchi <trimarchi@gandalf.sssup.it>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
References: <20090924154023.GA27480@localhost> <200909242103.48562.oliver@neukum.org> <20090924202107.4730f2af@lxorguk.ukuu.org.uk> <20090924211459.GB27963@localhost>
In-Reply-To: <20090924211459.GB27963@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Hovold wrote:
> On Thu, Sep 24, 2009 at 08:21:07PM +0100, Alan Cox wrote:
>   
>> On Thu, 24 Sep 2009 21:03:47 +0200
>> Oliver Neukum <oliver@neukum.org> wrote:
>>     
>
>   
>>> Am Donnerstag, 24. September 2009 17:40:23 schrieb Johan Hovold:
>>>       
>>>> Is there a reason why this was not fixed in ftdi_sio (and whiteheat?)
>>>> along with the other drivers?
>>>>         
>
>   
>>> No good reason. They escaped my grep pattern. Mea culpa.
>>>       
>
>   
>> ftdi_sio is correct with low_latency set as it uses a work queue to
>> process the packets received.
>>     
>
> AFAICT it only uses the work queue if tty_buffer_request_room fails to
> allocate enough space. This being the exception, the completion
> handler normally processes the packets in interrupt context and this is
> where I get my lockdep traces (and it happens every time I hit the echo
> or throttle paths).
>   
Hi,

Using two urb, double buffering and schedule a tasklet to complete the
the reading phase. The usb will use the other free urb during receiving 
process.
I think remove tty_latency is not a good fix.

Michael
> /Johan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

