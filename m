Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbXDWW6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbXDWW6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 18:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXDWW6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 18:58:22 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:16543 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbXDWW6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 18:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kMQlYa0qmxLScG2Qpp9XKtIvgX9+XsS3Ayr6UuyXwRkE6ipn46X3CdH/MUoMJXzeT+GHTvPF31d8F/SC91T1EBIR+jFOV2twVoNDSvMC3/WtuuF6F8WFYFA5GJd85/bdtoHg7fxW0T0Z/DeUiUByJcyIfgJf1nIrcYvdEhNHwOI=
Message-ID: <62eb359a0704231558we55f553u44a77183ed3e5340@mail.gmail.com>
Date: Mon, 23 Apr 2007 17:58:21 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: 2.6.20.7 locking up hard on boot
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@redhat.com>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <462C8525.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
	 <20070421013454.GB4016@stusta.de>
	 <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
	 <20070421053420.GA10974@suse.de> <20070421103632.GC4016@stusta.de>
	 <462C8525.76E4.0078.0@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm honestly not sure how to try what you suggested to try, since I'm
nothing even remotely close to a kernel geek and it was over my head.
However, I'd gladly test anything that you think would be worth
testing, if you would please put it in way that I could understand,
such as "change line 'foo' in probe.c into 'foolio'"

Thanks again for all of your help,
Marcos

On 4/23/07, Jan Beulich <jbeulich@novell.com> wrote:
> Given that all of the reports are in cases when the adjustment is *not*
> being done (and only a message is being printed), I can only assume that
> the breakage results from the adding of PCI_BASE_ADDRESS_SPACE_IO
> into the resource flags. I considered this unconditional setting of the flags
> odd already in the original code, and added this extra flag only for
> consistency reasons (because the settings reported by X indicated that
> this was missing). Perhaps the adjustment (original and the added
> extra flag) shouldn't be done if IORESOURCE_IO wasn't already set.
> Perhaps one of those seeing the issue could try out returning from the
> function right after that printk(), without any adjustment to the flags.
>
> Jan
>
>
