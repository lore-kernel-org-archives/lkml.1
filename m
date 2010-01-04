Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960Ab0ADAvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0ADAvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925Ab0ADAvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:51:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:38454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab0ADAvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:51:46 -0500
Message-ID: <4B413CB8.1050808@kernel.org>
Date: Mon, 04 Jan 2010 09:56:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Hans Werner <HWerner4@gmx.de>, linux-kernel@vger.kernel.org, trenn@suse.de,
       mmalygin@ked.de, hancockrwd@gmail.com, greg@kroah.com
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe
 issue?
References: <20091230120428.5780@gmx.net> <20100103221142.GA16783@sig21.net> <4B41216F.4070906@kernel.org> <20100104004147.GA19558@sig21.net>
In-Reply-To: <20100104004147.GA19558@sig21.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/04/2010 09:41 AM, Johannes Stezenbach wrote:
> I've updated bug#14314.  It is certainly a BIOS issue, but the
> "spurious IRQ" check deals way better with it than the previous
> 30sec hang waiting for timeout.  IMHO the patch should be merged
> into mainline asap.  Or do you think it has any downside?

The danger is that when the hardware is actually malfunctioning and
causing IRQ storm, the driver will tell the IRQ subsystem that the
IRQs aren't spurious.  This will bypass the IRQ storm detection logic
and lead to complete system lockup under such conditions.  Small
modification to the patch should remove that problem.  I'll post an
updated patch soon.

Thanks.

-- 
tejun
