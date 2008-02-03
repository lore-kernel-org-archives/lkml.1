Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYBCRfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYBCRfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYBCRfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:35:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbYBCRfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:35:23 -0500
Message-ID: <47A5FB58.8040404@garzik.org>
Date: Sun, 03 Feb 2008 12:35:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: LPFC compilation error in 2.6.24-git12/git13
References: <47A58B05.6010702@oracle.com>	 <804dabb00802030320s5d60a871kbae9f48d67380384@mail.gmail.com> <804dabb00802030325v12cb95cen75179941fa4443cb@mail.gmail.com>
In-Reply-To: <804dabb00802030325v12cb95cen75179941fa4443cb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:
> --- lpfc_init.c.old     2008-02-03 19:26:20.000000000 +0800
> +++ drivers/scsi/lpfc/lpfc_init.c       2008-02-03 19:26:42.000000000 +0800
> @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>         uint16_t iotag;
>         int bars = pci_select_bars(pdev, IORESOURCE_MEM);
> 
> -       if (pci_enable_device_bars(pdev, bars))
> +       if (pci_enable_device_io(pdev))
>                 goto out;


As already discussed and pointed out on LKML and linux-scsi, this is the 
wrong change.  Look at the line above the one you changed -- we want mem 
not io.

	Jeff


