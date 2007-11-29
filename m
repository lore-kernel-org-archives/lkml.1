Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbXK2PlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbXK2PlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXK2Pkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:40:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:26345 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805AbXK2Pkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:40:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J0X+j4rRu+YBE4UDJa3vfvhAVVR4cApHcT1s1+bj5KBXoEgxiOf41p8zxXKPS8ZsfCF+sm/cLP6Oyeh2oHznohElAOQyPfmgyPkX5dJObJk29fAF/Jfh6FDCYZwFM/zLCYzSoq9z3kDGFLCbxTqkHNQmbKrtVJPpbkh48kzdne0=
Message-ID: <2c0942db0711290740y7c730fb3te629454462df3efe@mail.gmail.com>
Date: Thu, 29 Nov 2007 07:40:49 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: bdupree@techfinesse.com
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46738.67.173.156.207.1196304247.squirrel@www.techfinesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46738.67.173.156.207.1196304247.squirrel@www.techfinesse.net>
X-Google-Sender-Auth: 87c490f1116f4c6b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 28, 2007 6:44 PM, <bdupree@techfinesse.com> wrote:
> I built the same dynticks-enabled 2.6.23.9 kernel on a nearly identical
> system with minor changes to reflect the slightly different hardware.
> These two systems have identical MSI E7210 MasterX FA6R motherboards (same
> model and revision.) The differences are as follows:
>
> behemoth (using Slackware 10.2)
> -----------------------------------------------------------------
> dual 2.4 GHz Xeons 400 MHz FSB
> LSI 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI
> Newer SATA/PATA Intel PIIX drivers
>
> titan (using Slackware 11.0)
> -----------------------------------------------------------------
> dual 2.0 GHz Xeons 533 MHz FSB
> Creative Labs SB Audigy LS (using ALSA driver)
> Older IDE PATA Intel PIIX drivers
>
> The result is that "behemoth" continues to exhibit 155,000 context
> switches per second at idle while "titan" shows about 25 - 30 context
> switches per second. Note that motherboard BIOS'es are at the same
> revision and configured identically.
>
> I guess (ugh) it's time for me to pull the MPT-Fusion U320 HBA and the
> SATA disks out of "behemoth" and configure it with old style IDE drives to
> be as close as possible to "titan." Then I can add parts back and see when
> the problem occurs.

Well, the first thing that seems obvious is that you're using
different version of userspace, and the newer userspace is on the
system that behaves better.

The second thing that pops to mind: are you doing all these
measurements booted into single user mode (init=/bin/bash or
somesuch)? If not, then I don't think we can pin this on the hardware
quite yet.
