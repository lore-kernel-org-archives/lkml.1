Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400Ab0AKM1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0AKM1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958Ab0AKM1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:27:34 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.42]:56354 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0AKM1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:27:33 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 07:27:33 EST
Message-ID: <4B4B1764.2060005@sirrix.com>
Date: Mon, 11 Jan 2010 13:19:48 +0100
From: Marcel Selhorst <m.selhorst@sirrix.com>
Organization: Sirrix AG Security Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100110 Thunderbird/3.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Debora Velarde <debora@linux.vnet.ibm.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm_infineon: Fix suspend/resume handler for pnp_driver
References: <87d41xu18p.fsf@devron.myhome.or.jp>	<20100105155900.7cf92358.akpm@linux-foundation.org> <87vdfasv8z.fsf@devron.myhome.or.jp>
In-Reply-To: <87vdfasv8z.fsf@devron.myhome.or.jp>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.1.134; VDF: 7.10.2.156; host: mail.selhorst.net); id=3089-SZGBJ3
X-Df-Sender: 174499
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I guess it might be tpm_infineon can't suspend/resume properly. However,
> with it, I don't know what happen actually. (it might be, tpm can't
> verify the security issue on suspend/resume process? or can't wakeup
> from tpm? or spend power?  or other?)

On suspend, the TPM framework sends a command "TPM_SaveState" to the chip to
inform it about the upcoming suspend. Therefore it is necessary to have the
function tpm_pm_suspend called (either directly or via pnp). On resume, the
state will automatically be restored by the TPM.

The patch looks good to me, but I haven't had a chance to test it, yet.
As soon as I did, I'll get back to you.

Thanks,
Marcel Selhorst
-- 
Sirrix AG security technologies -- http://www.sirrix.com
Dipl.-Ing. Marcel Selhorst  eMail: m.selhorst@sirrix.com
Tel: +49 (234) 610071-126   Fax: +49 (234) 610071-526
Tel: +49 (681)  95986-126   Fax: +49 (681)  95986-526
Get my public key from keyserver, KeyId: 0x7C9821CC
Fingerprint 4138 E617 E62E 79D3 E663 BE5A 14E7 1CD8 7C98 21CC

Vorstand: Ammar Alkassar (Vors.), Christian Stueble
Vorsitzender des Aufsichtsrates: Prof. Dr. Kai Rannenberg
Sitz der Gesellschaft: Homburg/Saar, HRB 3857 Amtsgericht Saarbruecken

This message may contain confidential and/or privileged information.
If you are not the addressee, you must not use, copy, disclose or
take any action based on this message or any information herein.
If you have received this message in error, please advise the sender
immediately by reply e-mail and delete this message.
