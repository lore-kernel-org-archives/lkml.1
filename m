Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZJLPTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZJLPTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZJLPTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:19:02 -0400
Received: from mail.pc-doctor.com ([66.224.119.10]:42893 "EHLO
	mail.pc-doctor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZJLPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:19:00 -0400
Date: Mon, 12 Oct 2009 08:18:18 -0700 (PDT)
From: Ben Efros <ben@pc-doctor.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-ID: <3481621.571561255360698793.JavaMail.root@mail.pc-doctor.com>
In-Reply-To: <Pine.LNX.4.44L0.0910121052550.11420-100000@netrider.rowland.org>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.148.190.25]
X-Mailer: Zimbra 5.0.18_GA_3011.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3011.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Alan Stern" <stern@rowland.harvard.edu> wrote:

> > >  Signed-off-by: Ben Efros <ben@pc-doctor.com>
> > 
> > Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > > --- linux-2.6.31.1/drivers/usb/storage/transport.c       
> 2009-09-24 08:45:25.000000000 -0700
> > > +++ linux-2.6.31.1.new/drivers/usb/storage/transport.c       
> 2009-10-11 08:06:26.000000000 -0700
> > > @@ -696,7 +696,7 @@ void usb_stor_invoke_transport(struct sc
> > >                  /* device supports and needs bigger sense buffer
> */
> > >                  if (us->fflags & US_FL_SANE_SENSE)
> > >                          sense_size = ~0;
> > > -
> > > +Retry_Sense:
> > >                  US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
> > >  
> > >                  scsi_eh_prep_cmnd(srb, &ses, NULL, 0,
> sense_size);
> > > @@ -723,6 +723,12 @@ void usb_stor_invoke_transport(struct sc
> > >                  if (temp_result != USB_STOR_TRANSPORT_GOOD) {
> > >                          US_DEBUGP("-- auto-sense failure\n");
> > >  
> > > +                        if ((us->fflags & US_FL_SANE_SENSE) &&
> > > +                            sense_size != US_SENSE_SIZE) {
> > > +                                sense_size = US_SENSE_SIZE;
> > > +                                US_DEBUGP("-- retry without
> SANE_SENSE\n");
> > > +                                goto Retry_Sense;
> > > +                        }
> 
> Except that this is wrong.  We can retry if temp_result == 
> USB_STOR_TRANSPORT_FAILURE, but we should not retry if temp_result ==
> USB_STOR_TRANSPORT_ERROR.
> 

Agreed.
