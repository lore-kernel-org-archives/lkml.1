Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbXBONfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbXBONfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbXBONfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:35:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:64111 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741AbXBONfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SrG7Jh9xJ41mowv47VO3nen2WCesEKw3uaSnOva3LABOvQxJjG9ThknYEkH5Zuf23LiRwNXA+hYcQVAOx0hWtt7OvQ7diMfctinGIyEeje4eJg4lYRmG9mbTU+J6vTiH+ldbgZbTblzB98lkkaF+XT6oD1N1eByvIPN3a/49Te8=
Message-ID: <d120d5000702150535w1ec29473x5d173704389811aa@mail.gmail.com>
Date: Thu, 15 Feb 2007 08:35:42 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 9/11] Panic delay fix
Cc: "Zachary Amsden" <zach@vmware.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akp=m@osdl.org>, "Andi Kleen" <ak@muc.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>, Alan <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1171493506.19842.179.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <1171493506.19842.179.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 2007-02-05 at 19:53 -0800, Zachary Amsden wrote:
> > Failure to use real-time delay here causes the keyboard to become demonically
> > possessed in the event of a kernel crash, with wildly blinking lights and
> > unpredictable behavior.  This has resulted in several injuries.
>
> The problem is the normal one when we introduce a new concept into the
> kernel; there are two kinds of udelay, and they've been conflated.  The
> most common case is a delay for real hardware devices; this can be
> eliminated for paravirtualization.  The other cases, the tiny minority,
> are visible delays (keyboard leds), not knowing if they're necessary
> (very early boot), and async events (other CPUs coming up): ie.
> everything else.
>

Just for the record - I believe that i8042 is fine as is now. The only
place where real delay needs to be enforced is panic.c - it should
call panic blink routine once every 1 ms.

-- 
Dmitry
