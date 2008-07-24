Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYGXNc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYGXNc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYGXNcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:32:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50660 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbYGXNcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:32:16 -0400
Message-ID: <48888444.1020305@zytor.com>
Date: Thu, 24 Jul 2008 09:31:48 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() smp-safe
References: <48885DDC.9010003@fujitsu-siemens.com>
In-Reply-To: <48885DDC.9010003@fujitsu-siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Wilck wrote:
> Hi Thomas and Peter, hi everyone,
> 
> Asynchrounous events (e.g.SMIs) which occur during the APIC timer 
> calibration can cause timer miscalibrations, sometimes by large amounts.
> 
> This patch fixes this by two separate measures:
>   a) make sure that no significant interruption occurs between APIC and
>      TSC reads
>   b) make sure that the measurement loop isn't significantly longer
>      than originally intended.
> 
> I am sorry, due to a misconfiguration of our SMTP server I need to send 
> the patch as attachment.
> 

The other thing we may want to consider is doing multiple runs of the 
calibration loop.  I suspect we'd get a more accurate result running, 
say, 9 loops of the 1/9 the current duration and looking either for the 
best result or the median (NOT the mean.)

	-hpa

