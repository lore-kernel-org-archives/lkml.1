Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbXE0Vtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbXE0Vtm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbXE0Vte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:49:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8751 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbXE0Vtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VKdpWrxKfRFj16RJ3HIyvWasgd6VDVb+OQEUEuuX+WAobxCHvyqoaKac+TU/ruINlK/Sv4UrubfxZ8lBUJlUQjIUrHei5VDTJshKSNZAx5Gwrtd0BzlahsI3orV6eYCfYCEF0Eos0GmcHb4JZVIgrI2gOu+2/fMtT1QasXk2tco=
Message-ID: <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
Date: Sun, 27 May 2007 23:49:30 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Pavel Machek" <pavel@ucw.cz>, "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oliver@neukum.org>
In-Reply-To: <20070527204955.GA22202@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705272229.21263.rjw@sisk.pl> <200705272231.54535.rjw@sisk.pl>
	 <20070527204955.GA22202@srcf.ucam.org>
X-Google-Sender-Auth: c24ddbea45f237bb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/27/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Sun, May 27, 2007 at 10:31:53PM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Use a hibernation and suspend notifier to disable the firmware requesting
> > mechanism before a hibernation/suspend and enable it after the operation.
>
> This avoids the problem of .resume methods calling userspace while
> userspace is frozen and a resulting hang, but does it actually result in
> the drivers beginning to work again? If we remove process freezing in
> STR, this should just work[1] without the need to complicate things. On
> the other hand, if we don't want to support these functions in the
> suspend and resume methods we could just audit the kernel and remove
> them all.

What exactly is the problem we see here? The timeout of the firmware loader?
What goes wrong with frozen userspace, usually there is only a netlink
message sent from the kernel, which should be received and handled
just fine when userspace is running again.

Thanks,
Kay
