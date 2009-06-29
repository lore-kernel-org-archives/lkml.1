Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbZF2GUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbZF2GUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZF2GT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:19:58 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:44527 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZF2GT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:19:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=aLYmiD+K4L4fWyhVIBSnHmq+hbFHNSdf8lI4Wj5NufRkZC0iM0e7exbITb8XH0dzdV
         5UMNu6XhBCVue+GEgEpchmmjiPwCrlke5xAMthip2ggpv4mntMt4RFyEWBAGTsbVzB48
         LnfYQob0CZi6pDSCLO/wqHQ6ZVzV7O/GOwI+E=
Date: Sun, 28 Jun 2009 23:19:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Daniel Ribeiro <drwyrm@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Harald Welte <laforge@gnumonks.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] PCAP touchscreen driver (for 2.6.32)
Message-ID: <20090629061955.GE12821@dtor-d630.eng.vmware.com>
References: <1246122138.3727.12.camel@brutus> <5d5443650906280015x4bddefa5v9dd36f888c5f2e92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650906280015x4bddefa5v9dd36f888c5f2e92@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 12:45:17PM +0530, Trilok Soni wrote:
> Hi Daniel,
> 
> 2009/6/27 Daniel Ribeiro <drwyrm@gmail.com>:
> > +
> > +       err = request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> > +                       pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> > +       if (err)
> > +               goto fail;
> > +
> > +       err = input_register_device(pcap_ts->input);
> > +       if (err)
> > +               goto fail_touch;
> 
> Please move request_irq after input_register_device, as IRQ can get
> fired before input device gets available, right?
> 

Actually it is OK to have IRQs fired before the device is registered.
Input core guarantees that input device allocated with
input_allocate_device() will survive if events are sent through it. The
events will not be delivered anywhere, for obvious reason, but
everything else should be fine. In fact, if device has an event()
handler then it has to be fully operational (that includes IRQ reserved
and ready, unless the driver implements open/close methods) before
calling input_register_device - the handlers that will attach to the
device have every right to start sending events back to the device right
away and expect them to be handled properly.

-- 
Dmitry
