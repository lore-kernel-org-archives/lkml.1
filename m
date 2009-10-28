Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZJ1Qfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZJ1Qfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbZJ1Qfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:35:42 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42663 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZJ1Qfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:35:41 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KS8GR9-04-91E-02
X-M-MSG: 
Date: Wed, 28 Oct 2009 17:35:34 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
CC: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] amd64_edac: syndromes loading
Message-ID: <20091028163534.GA625@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Oct 2009 16:35:32.0367 (UTC) FILETIME=[AAD821F0:01CA57EC]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been pondering how to avoid adding almost 15K of syndrome tables to
the edac driver.

The syndrome tables are used for mapping a correctable ECC to the
corresponding DIMM and thus pinpointing the DIMM about to fail. There
are two flavors of syndromes based on the ECCs: x4 and x8. The x4 table
of size 540 u16 values is already in the driver but the x8 is much
bigger (4864 u16) and I wouldn't want to add it statically into the
driver.

Rather, I'd like to dynamically load them depending on the DRAM
configuration of each node. The two attached patches do that using
the request_firmware() interface. This way, the syndrome tables could
be added as binary blobs in drivers/edac/ and then installed with
'make firmware_install'. This way we avoid polluting driver code with
humongous u16 arrays of ECC syndromes.

What do you guys think, could that be an acceptable approach? Any
suggestions/comments are welcome.

Thanks.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

