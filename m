Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYETKxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYETKxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbYETKw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:52:57 -0400
Received: from zm1.veloxia.com ([213.149.227.2]:36047 "HELO zm1.veloxia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932130AbYETKw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:52:56 -0400
Message-ID: <4832AD84.6090300@hvsistemas.es>
Date: Tue, 20 May 2008 12:52:52 +0200
From: Javier Herrero <jherrero@hvsistemas.es>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Russell King <rmk+lkml@arm.linux.org.uk>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Bryan Wu <cooloney@kernel.org>
Subject: Re: b4aa54d951d38d7a989d6b6385494ef5ea7371d7 breaks some serial configurations
References: <20080520073556.GA1090@flint.arm.linux.org.uk> <483286AF.2090302@hvsistemas.es> <20080520083217.GA10172@flint.arm.linux.org.uk>
In-Reply-To: <20080520083217.GA10172@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see... would be OK to move the asm/serial.h include to its original 
position and to modify the asm-blackfin/serial.h in this way to avoid 
duplicate definition warnings, or would it be too ugly?:

/*
 * include/asm-blackfin/serial.h
 */

+#ifdef SERIAL_EXTRA_IRQ_FLAGS
+#undef SERIAL_EXTRA_IRQ_FLAGS
+#endif

#define SERIAL_EXTRA_IRQ_FLAGS IRQF_TRIGGER_HIGH

Regards,

Javier

Russell King escribió:
> On Tue, May 20, 2008 at 10:07:11AM +0200, Javier Herrero wrote:
>> Does the problem arise due to the change of inclusion order of 
>> asm/serial.h (from after 8250.h to before 8250.h) ?
>
> Yes.  It was placed where it was because of the dependencies of
> asm/serial.h on the code between the two places.
>
> The alternative solution is to get rid of the CONFIG_* compatibility
> and update those asm/serial.h which reference the old symbols.
> However, that's a larger patch.
>

-- 
------------------------------------------------------------------------
Javier Herrero                            EMAIL: jherrero@hvsistemas.com
HV Sistemas S.L.                          PHONE:         +34 949 336 806
Los Charcones, 17A                        FAX:           +34 949 336 792
19170 El Casar - Guadalajara - Spain      WEB: http://www.hvsistemas.com 

