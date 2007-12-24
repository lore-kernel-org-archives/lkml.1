Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXLXM76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXLXM76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 07:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXLXM7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 07:59:49 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38631 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbXLXM7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 07:59:49 -0500
Date: Mon, 24 Dec 2007 14:01:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Correct use of __init and __devinit
Message-ID: <20071224130143.GA27530@uranus.ravnborg.org>
References: <8b67d60712230856o73bc89d7u142b93fc47b7533b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712230856o73bc89d7u142b93fc47b7533b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 04:56:14PM +0000, Adrian McMenamin wrote:
> Could someone here help settle this argument?
> 
> I have written a driver (for the CD Rom on the Sega Dreamcast). I have
> marked various initialisation functions - including probe() and the
> functions that it, and only it, calls, as __init.
> 
> Other developers tell me I should mark them as __devinit.
> 
> However I think this is wrong as:
> 
> * The CD on the Dreamcast is not and will never be a hotpluggable device
> 
> * The Dreamcast is a limited memory device and if marking various
> functions as __init helps save memory that is A Good Thing
> 
> It has been put to me that while the use case (not hotpluggable) is
> correct, it is still better practice to use __devinit
If you use the register* functions of the driver model then
you are no longer in 100% control when your functions are
called.
So of the principle of least suprise it is best to use __devinit
for the probe function as most other drivers do. And if
the driver model happens to call your probe function after
init time then we will not oops.

So wit other words - use same pattern a other drivers and accept
that we could have saved a few hundred bytes extra but we do not do so.

	Sam
