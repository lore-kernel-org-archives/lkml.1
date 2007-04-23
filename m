Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXDWIFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXDWIFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbXDWIFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:05:54 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:38225
	"EHLO gwia-smtp.id2.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752885AbXDWIFm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:05:42 -0400
Message-Id: <462C8525.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 23 Apr 2007 09:06:29 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Adrian Bunk" <bunk@stusta.de>
Cc: <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Marcos Pinto" <markybob@gmail.com>, "Alan Cox" <alan@redhat.com>,
       "Greg KH" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20.7 locking up hard on boot
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
 <20070421013454.GB4016@stusta.de>
 <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
 <20070421053420.GA10974@suse.de> <20070421103632.GC4016@stusta.de>
In-Reply-To: <20070421103632.GC4016@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Considering where it failed and that 2.6.20.3 worked, I would be 
>extremely surprised if this wasn't one more report of 
>adjust-legacy-ide-resource-setting.patch breaking booting (and we 
>already have confirmed reports for this)...
>
>But AFAIK we still don't understand how this patch managed to break 
>things.

Given that all of the reports are in cases when the adjustment is *not*
being done (and only a message is being printed), I can only assume that
the breakage results from the adding of PCI_BASE_ADDRESS_SPACE_IO
into the resource flags. I considered this unconditional setting of the flags
odd already in the original code, and added this extra flag only for
consistency reasons (because the settings reported by X indicated that
this was missing). Perhaps the adjustment (original and the added
extra flag) shouldn't be done if IORESOURCE_IO wasn't already set.
Perhaps one of those seeing the issue could try out returning from the
function right after that printk(), without any adjustment to the flags.

Jan

