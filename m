Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbYKRFuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbYKRFuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYKRFuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:50:06 -0500
Received: from main.gmane.org ([80.91.229.2]:50236 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbYKRFuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:50:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: jfs problem
Date: Mon, 17 Nov 2008 23:47:47 -0600
Message-ID: <49225703.7060905@shaw.ca>
References: <e38d12ff0811171408k2e77cf9bt6f89e448194ebe32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <e38d12ff0811171408k2e77cf9bt6f89e448194ebe32@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vul wrote:
> I have a JFS problem occuring randomly. The hardware that this happens
> on is an Asus M50VM laptop.
> 
> /dev/sda5 is mounted on /
> 
> Kernel version is 2.6.27.4 with dm-bbr (device mapper - bad block
> relocation), fbcondecor, and squashfs patches.
> 
> dmesg:
> [  130.405776] DMAR:[DMA Write] Request device [00:1f.2] fault addr fff9f000
> [  130.405780] DMAR:[fault reason 05] PTE Write access is not set
> [  130.405828] ERROR: (device sda5): diRead: i_ino != di_number
> [  130.406133] ERROR: (device sda5): remounting filesystem as read-only
> [  130.406136]
> [  130.406146] jfs_lookup: iget failed on inum 188808
> [  131.212899] DMAR:[DMA Write] Request device [00:1f.2] fault addr fff9f000
> [  131.212903] DMAR:[fault reason 05] PTE Write access is not set
> [  131.212962] ERROR: (device sda5): stack overrun in dtSearch!
> [  131.212968] btstack dump:
> [  131.212972] bn = 0, index = 0
> [  131.212975] bn = 5402c5, index = 0
> [  131.212979] bn = 0, index = 0
> [  131.212982] bn = 5402c5, index = 0
> [  131.212985] bn = 0, index = 0
> [  131.212988] bn = 5402c5, index = 0
> [  131.212991] bn = 0, index = 0
> [  131.212995] bn = fffffffffffffff4, index = 7336
> [  131.213015] jfs_lookup: dtSearch returned -5

This doesn't look like any JFS problem, more like DMAR is blocking a 
write request from a controller to an area that it doesn't think should 
be writable. Can you post dmesg and lspci -vv from bootup?

