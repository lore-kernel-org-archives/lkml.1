Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXGJSmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXGJSmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXGJSma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:42:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbXGJSm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:42:29 -0400
Message-ID: <4693D2EE.3020401@redhat.com>
Date: Tue, 10 Jul 2007 14:41:50 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <20070709111431.2fd3fba9@the-village.bc.nu>
In-Reply-To: <20070709111431.2fd3fba9@the-village.bc.nu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2007 06:14 AM, Alan Cox wrote:
> Are the shortlogs useful - yes .. they catch what appear to be mistakes
> 
> Specifically: What happened to the aacraid ioctl security fix ? Did someone decide it
> wasn't needed or did it get lost somewhere on the way ?
> 
> While this looks scary the only obvious exploit cases are where the user can
> open a device level file on an AACraid. Very few people put scanners or CD
> devices on one so the actual impact is probably minimal.

I can't find that patch in any SCSI git tree.

> --- drivers/scsi/aacraid/linit.c~	2007-07-09 10:51:55.653223304 +0100
> +++ drivers/scsi/aacraid/linit.c	2007-07-09 10:51:55.653223304 +0100
> @@ -453,6 +453,8 @@
>  static int aac_ioctl(struct scsi_device *sdev, int cmd, void __user * arg)
>  {
>  	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
> +	if (!capable(CAP_SYS_RAWIO))
> +		return -EPERM;

