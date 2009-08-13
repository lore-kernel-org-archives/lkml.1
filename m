Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZHMMP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZHMMP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 08:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZHMMP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 08:15:56 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37129 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZHMMPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 08:15:55 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [RFC] usb: Add support for runtime power management of the hcd
Date: Thu, 13 Aug 2009 14:16:41 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <200908081625.57333.rjw@sisk.pl> <20090813002925.GA2532@srcf.ucam.org> <20090813003544.GB2532@srcf.ucam.org>
In-Reply-To: <20090813003544.GB2532@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908131416.42189.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. August 2009 02:35:44 schrieb Matthew Garrett:

> The power savings from this are measurable but not huge - it still seems

How large?

> like a decent optimisation. The main problem is that BIOS bugs on some
> Dell laptops will kill USB if this is used, so we either default to off
> or add some quirks to handle that case (I have some ideas in that
> respect).

Your earlier failures don't look promising regarding BIOSes.
What do you have in mind?

> @@ -1968,6 +1972,9 @@ struct usb_hcd *usb_create_hcd (const struct
> hc_driver *driver, INIT_WORK(&hcd->wakeup_work, hcd_resume_work);
>  #endif
>
> +	pm_runtime_enable(dev);

So you don't get a reference from that?

> +	pm_runtime_get(dev);

What happens if you get a runtime suspend request in between? Is this a flaw
of the API?

	Regards
		Oliver

