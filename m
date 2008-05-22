Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbYEVFAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbYEVFAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYEVE7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:59:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:10277 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYEVE7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOj4CkotqRED8XzgXPEdqykpVnl66qT8pX/AtjtEYsVKDGXGl+bXVwZENFQ2Yz8e2+heg9/ZLT6uDD+els5IeMsjkI9K205Q3ncWHhF1Lr5ygiJi0V6lennI/xDSfvxbTWKlpaqNeItE+IpQjOoIvPSVAnm/YrwLKcBvXbWMTmE=
Message-ID: <b49af93b0805212159x46226c63i948e90e263283efc@mail.gmail.com>
Date: Thu, 22 May 2008 10:29:50 +0530
From: "vijay anand" <vijayanand.sj@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [BUG] cdc-acm driver module
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200805211525.08054.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b49af93b0805210601n38030150w643565b60edc85da@mail.gmail.com>
	 <200805211525.08054.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Thank you very much for replying.

Given below is the snip from '\linux-2.6.25\drivers\usb\core\driver.c'
for 'usb_driver_release_interface'

****SNIP*****
 * This can be used by drivers to release an interface without waiting
 * for their disconnect() methods to be called.  In typical cases this
 * also causes the driver disconnect() method to be called.
****END*****

What happens when the function 'usb_deregister' in 'acm_exit'  gets
called before the control reaches the 'acm_disconnect'? Is there any
possibility for this? If yes what happens during this scenario?

Thanks,
VJ



On Wed, May 21, 2008 at 6:55 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Mittwoch 21 Mai 2008 15:01:21 schrieb vijay anand:
>> What happens when the control never reaches the 'acm_disconnect'. Like simply
>> loading the driver and unloading the driver when the device is still in use.
>
> Even in this case disconnect() will be called.
> The only time it will not be called is if probe() was never called. But
> in that case no interface has been claimed. All is well.
>
>        Regards
>                Oliver
>
