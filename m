Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbYDOX0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbYDOX0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYDOX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:26:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:53023 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbYDOX0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lsr1Zl/Xha5gAK6LF8hLwVTsIvma3GgE9TUMRjEtaevu5iUQLw1/fBRIfnPBINM8OopAX7GZ1gapAhYY/hIBmn4AlasRXBRUXuJZo5L1nzEKKXFtCX/7gE1bCfmclsxz2xPZo6sG+06dQI74URtvdFA3z0UadWgsKwbmQZOE2Eg=
Message-ID: <48053985.8080702@gmail.com>
Date: Wed, 16 Apr 2008 08:25:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Frans Pop <elendil@planet.nl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
References: <200804021524.27222.elendil@planet.nl>	<200804021820.04610.elendil@planet.nl>	<20080402194938.GI24237@csclub.uwaterloo.ca>	<200804031947.07674.elendil@planet.nl>	<48017248.4030600@gmail.com>	<20080414134734.GB7385@csclub.uwaterloo.ca>	<20080414145302.4239b0b9@core>	<480414E6.2090205@gmail.com> <20080415110419.785a75ee@core>
In-Reply-To: <20080415110419.785a75ee@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Always loading generic or ata_generic used to be safe.  It's still 
>> pretty safe but not as much as before.  Nowadays, there are good number 
> 
> ata_generic is always safe unless you force it to grab every class
> device. By default it grabs only those devices we know obey the class
> interface well enough and for which we have no proper driver (usually
> because there are no documents). Ditto for ide/pci/generic.
> 
> The trickier one is pata_legacy, which tries to be smart and knows about
> the known exception so *should* always be safe. The old IDE legacy driver
> lacks these smarts so in some cases will do the wrong thing even if
> loaded last.

Right, I was thinking about drivers/ide/ide-generic.c which just grabs 
every known legacy IO ports.  This actually caused rather serious 
problems on some ATI controllers under certain configurations.  :-(

-- 
tejun
