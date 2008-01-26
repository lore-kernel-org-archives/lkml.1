Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYAZTag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYAZTag (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 14:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYAZTa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 14:30:27 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54908 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbYAZTa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 14:30:26 -0500
Date: Sat, 26 Jan 2008 20:30:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126193036.GA25884@uranus.ravnborg.org>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126191717.GA25701@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I checked up on the synclink.c warning.
> We have the following code:
> 
> static void synclink_remove_one (struct pci_dev *dev);
> 
> ...
> 
> static struct pci_driver synclink_pci_driver = {
>         .remove         = __devexit_p(synclink_remove_one),
> };
> 
> ...
> 
> static void __devexit synclink_remove_one (struct pci_dev *dev)
> {
> }
> 
> And I double checked the preprocessed source to check
> that we applied the __attribute__((__used__)) to the function.
> 
> Investigating a bit more I realized that gcc looses the
> __used__ attribution due to the prototype.
> So there are two correct fixes:
> a) move the function up so we do not need the forward
>    declaration
> b) add a __devexit to the forward decalration too.
> 
> I strongly prefer the first version and this is the
> correct fix for these cases.
> 
> Do we have a gcc bug here - I did not see a definitive answer in gcc docs?

I have reported it now - follow:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=34985

	Sam
