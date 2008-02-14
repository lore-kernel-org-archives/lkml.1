Return-Path: <linux-kernel-owner+w=401wt.eu-S1762454AbYBNOrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762454AbYBNOrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbYBNOrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:47:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:9654 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbYBNOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H8SUxl4UbhHfvTFIYOH5H54URoyvdgZ23jw8aL9lepqkXlJtd5AHdby0O5SIogaJoUmQTOK91t0VOBtKde3swkUHjEcGW/ZZW8ERwZ4qcp6MstMlGKERznk+2JtPMA/K8nlAzGCQAbhLYeaW4x4uMFfCHpkN3RpsOolyIQdqUEE=
Message-ID: <47B45469.5070103@gmail.com>
Date: Thu, 14 Feb 2008 15:47:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sergio Luis <sergio@larces.uece.br>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "gdth: update deprecated pci_find_device" is incorrect
References: <47B453D3.5060707@gmail.com>
In-Reply-To: <47B453D3.5060707@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2008 03:44 PM, Jiri Slaby wrote:
> Hi,
> 
> commit
> 99109301d103fbf0de43fc5a580a406c12a501e0
> in jejb/scsi-rc-fixes-2.6.git is incorrect. You don't decrement pci 
> refcount on exit. Also you do not so on fail paths... I wonder why these 
> mistakes happen every second time somebody tries to do such change.
> 
> It leaked into mainline yet after "whole" two days, but what exactly 
> drives me crazy is, that Jeff commented it in similar way and nobody 
> reflected it!

BTW if you have more than one card, you protected the driver from no race, since 
you don't pci_dev_get of successfully grabbed cards.
