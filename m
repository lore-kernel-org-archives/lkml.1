Return-Path: <linux-kernel-owner+w=401wt.eu-S1422748AbXCGRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422748AbXCGRL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXCGRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:11:28 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:47963 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422748AbXCGRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=NwXzVx0wTBVSTAPBz/UCEqvbNBugpZnVf7nqWXQH9HGhRBz6QEgyW6lBbY/oL/p/7bT8v4Qg1l6EOduL9t/PjTERjbWGtPvHze4hCWwA4kOWbCoi3eQ7PxTEtNgkOSGqIh1zLYtJ7xN4fLllnA4B1wAGoDQx3RuXbCvvABjkdBw=
Date: Wed, 7 Mar 2007 19:11:27 +0200
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <612284348.20070307191127@gmail.com>
To: NZG <ngustavson@emacinc.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: passing function pointers through platform devices?
In-Reply-To: <200703061246.29615.ngustavson@emacinc.com>
References: <200703061246.29615.ngustavson@emacinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello NZG,

Tuesday, March 6, 2007, 8:46:29 PM, you wrote:

> I'm developing an SPI- bus >MMC/SD block driver translation layer.
> As part of this layer the write protect and card detect lines need to be read.
> The method for determining the state of these lines will be board specific.

> Is it appropriate to pass a function pointer through a platform device
> (declared in the mach initialization) to implement card_available and 
> write_protect function calls?
> Or is there a cleaner way to do it?

  Apparently it must be appropriate, because that's pretty natural
and clean - if you can pass data, why wouldn't you be able to pass
methods?

  I assume your usecase is to pass board-specific code, defined in
machine definition, down to a device driver. We (handhelds.org) go
even further and recently tried passing function pointers in opposite
direction - from device driver to client code which will use the
device, via device's platform_data.

  That essentially implements virtual methods on devices, allowing
device clients to perform operations on them without bothering to know
how actually the operation is implemented, i.e. offers better
functionality separation and code reuse which OOP offers.

  Either way, be assured that you're not the only one who puts Linux
Driver Model under full use.

> thank you,
> NZG


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

