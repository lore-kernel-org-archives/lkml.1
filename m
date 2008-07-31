Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbYGaT1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbYGaT1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYGaT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:27:12 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40780 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYGaT1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:27:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=jxKhBTQPy6fiuQ/9DfoaXtUNPeTItBXSHifuDtlBR8xPFDN68ZoST3BtP+KouQlQw9L38Uc5sNVlrkfwUwZoWTSfzGJzd1fFZXIsodQgSHlRQSOQdqk9pUKZZJ6uB1EI;
Message-ID: <4892120A.8010401@simon.arlott.org.uk>
Date: Thu, 31 Jul 2008 20:27:06 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before      late_initcall
 and move level 6s (sync) first
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org> <48920481.7010702@simon.arlott.org.uk> <48920AC1.3040506@keyaccess.nl>
In-Reply-To: <48920AC1.3040506@keyaccess.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 19:56, Rene Herman wrote:
> On 31-07-08 20:29, Simon Arlott wrote:
> 
>> Ok - so there could be some big improvements to be had by making the 
>> hcd init happen as early as possible and the device initcalls later?
> 
> Arjan also needed a pre device_initcall() level for PCI core init now 
> that the async device initcalls weren't governed just by link order 
> anymore. He reused the device_initcall_sync() level, moving it to before 
> device_initcall() itself (it used to be just behind).
> 
> Your above notion sounds like another good reason for inserting a real 
> new level just before device_initcall(); if you move any of the device 
> init to late initcall(), late_initcall() loses too much of its utility 
> I'd feel (see start of this thread with various late_initcalls wanting 
> to assume stuff).

Well, the late_initcall idea was just for testing, to make the device 
driver parts later while moving usb/ up in link order.

-- 
Simon Arlott
