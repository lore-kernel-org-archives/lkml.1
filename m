Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZIVHQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZIVHQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 03:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZIVHQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 03:16:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:45279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZIVHQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 03:16:12 -0400
Date: Tue, 22 Sep 2009 09:16:20 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PCI PM: Read device power state from register after
 updating it (rev. 2)
Message-ID: <20090922091620.599ab046@infradead.org>
In-Reply-To: <200909212337.01812.rjw@sisk.pl>
References: <200909212337.01812.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009 23:37:01 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>  
> -	dev->current_state = state;
> +	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
> +	dev->current_state = (pmcsr & PCI_PM_CTRL_STATE_MASK);
> +	/* Return error code if we have failed to change the state */
> +	if (dev->current_state != state)
> +		dev_info(&dev->dev, "Refused to change power state, "
> +			"currently in D%d\n", dev->current_state);

I would suspect that you want this message only once...
to avoid it flooding logs and such

or at least ratelimiting it


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
