Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZGWT2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZGWT2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 15:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZGWT2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 15:28:21 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:63263 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518AbZGWT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 15:28:20 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] hp-wmi: improve rfkill support
Date: Thu, 23 Jul 2009 21:28:18 +0200
User-Agent: KMail/1.9.9
Cc: mjg@redhat.com, maciej.rutecki@gmail.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4A65A2F9.1060509@tuffmail.co.uk>
In-reply-To: <4A65A2F9.1060509@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907232128.19735.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 19:28:20.0582 (UTC) FILETIME=[BCB67060:01CA0BCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> 1) Add support for reading the hardware blocked state.  Previously
> we read a combination of the hardware and software blocked states,
> reporting it as the software blocked state.  This caused some
> confusing behaviour.
> 
> 2) The software state is persistent, mark it as such.
> 
> 3) Check rfkill in the resume handler.  Both the hard and soft
> blocked states may change over hibernation.

I've added this to my local branch for .31 for my HP 2510p.
Light testing (linux only) showed no problems with .31-rc4.

One question: is it expected that pressing the hardware kill switch only 
enables the block for phy0? I guess it's probably sufficient.

$ ./rfkill list # after pressing hardware switch
0: phy0: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
1: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
2: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no

Looks like with bluetooth soft-blocked the wireless leds blink on wifi 
network traffic, while with bluetooth unblocked it stays on permanently.

Cheers,
FJP
