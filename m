Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYAZIWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYAZIWE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 03:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYAZIVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 03:21:54 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:34197 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752569AbYAZIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 03:21:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z1qhWqpATTwVGoYhKf+n9HnDCZ/AQOcoGwRRotIc2KUGLrQcR1z1y3MbOFB7eleDUBWj93qITCGds8bVzo/A4CTfCYFFfesiMSIFUuMppV9U53siDuG8V95fafBCn0Kro8LvPpaR0VqDYUPFYnUa+O/7ltnkeDDV5QH2zF/CfWI=  ;
X-YMail-OSG: HdE.jbkVM1m1n8pM1Am8j8X64Tp5GU3AZm4StDU5k6wwshqUrIiGl8.JRRlngWxz75AjlL6W2Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: romlinux@gmail.com
Subject: Re: [PATCH] Moving spinlock to struct usb_hcd
Date: Sat, 26 Jan 2008 00:21:50 -0800
User-Agent: KMail/1.9.6
Cc: greg@kroah.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1201329041.5807.20.camel@maxwell>
In-Reply-To: <1201329041.5807.20.camel@maxwell>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801260021.50786.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 January 2008, Romit Dasgupta wrote:
> This should help
> reduce contention to usb during high load where i/o is happening  to
> multiple hcds.

Looking at how this lock is used, contention doesn't look likely
to be an issue.  It's never held for long ...

> @@ -1106,9 +1103,9 @@ EXPORT_SYMBOL_GPL(usb_hcd_check_unlink_urb);
>  void usb_hcd_unlink_urb_from_ep(struct usb_hcd *hcd, struct urb *urb)
>  {
>         /* clear all state linking urb to this dev (and hcd) */
> -       spin_lock(&hcd_urb_list_lock);
> +       spin_lock(&hcd->hcd_urb_list_lock);
>         list_del_init(&urb->urb_list);
> -       spin_unlock(&hcd_urb_list_lock);
> +       spin_unlock(&hcd->hcd_urb_list_lock);
>  }
>  EXPORT_SYMBOL_GPL(usb_hcd_unlink_urb_from_ep);
>  

Do you have any proof that contention is an actual problem?
Because otherwise I see no benefit to such a change.

- Dave
 
