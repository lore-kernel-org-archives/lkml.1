Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbYA2WQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbYA2WQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYA2WQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:16:35 -0500
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:38264 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753832AbYA2WQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:16:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=iSsbpR0Hu925Brau94xG74nR8oDYsAK+s07UWgIl9s8XsHemq0jezBNi+Ieeco5NwcLLpnmI0BCqX99wi7WnpXoaC+7fba5wrdzNyGRwxcPQAzhVA44Vlc2PH0BGLrmDhIMwbc7NaqTwG8WeEuE+WVEqsFK6ALf7CQ77GD6rBKw=;
X-YMail-OSG: 1BYdo5AVM1lUFTm4pndGgkS.xWnBgd3gcumCWpSL6VGN3HcrhDQHzl5RgXOlNL7eIyKVjA--
X-Mailer: YahooMailWebService/0.7.162
Date: Tue, 29 Jan 2008 14:09:52 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: DMA mapping on SCSI device?
To: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
In-Reply-To: <479E6E8C.2090501@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <896139.88121.qm@web31812.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 1/28/08, Robert Hancock <hancockr@shaw.ca> wrote:
> The trick is that if an ATAPI device is connected, we (as
> far as I'm 
> aware) can't use ADMA mode, so we have to switch that
> port into legacy 
> mode.

Can you double check this with the HW architect of the
HW DMA engine of the ASIC?

> This means it's only capable of 32-bit DMA.
> However the other port 
> on the controller may be connected to a hard drive and
> therefore still 
> capable of 64-bit DMA.

If this is indeed the case as you've presented it here,
it sounds like a HW shortcoming.  I cannot see how the device
type (or protocol) dictate how the DMA engine operates.
They live in two different domains.

> The ideal solution would be to do mapping against a
> different struct 
> device for each port, so that we could maintain the proper
> DMA mask for 
> each of them at all times. However I'm not sure if
> that's possible. The 
> thought of using the SCSI struct device for DMA mapping was
> brought up 
> at one point.. any thoughts on that?

The reason for this is that the object that a struct scsi_dev
represents has nothing to do with HW DMA engines.

It looks like your current solution is correct and
x86_64's blk_queue_bounce_limit needs work.

    Luben

