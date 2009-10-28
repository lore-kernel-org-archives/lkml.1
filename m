Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZJ1R3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZJ1R3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbZJ1R3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:29:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:19820 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZJ1R3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:29:36 -0400
X-SpamScore: 7
X-BigFish: VPS7(zz98dN933frzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KS8J83-04-B1F-02
X-M-MSG: 
Date: Wed, 28 Oct 2009 18:28:53 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Doug Thompson <norsk5@yahoo.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] amd64_edac: syndromes loading
Message-ID: <20091028172853.GE625@aftab>
References: <20091028163534.GA625@aftab>
 <143841.81095.qm@web50110.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <143841.81095.qm@web50110.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Oct 2009 17:28:50.0738 (UTC) FILETIME=[1D38D120:01CA57F4]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 10:15:03AM -0700, Doug Thompson wrote:
> Where does the syndrome table/module/firmware live in the file system?
> In with the amd64 module area or elsewhere?

Yeah, I was thinking maybe drivers/edac/amd64_x(4|8).bin or so.

Alternatively, we could make the syndromes builtin thus removing the
requirement to go to userspace for the loading. For that we'll need
two new .c files in drivers/edac/ which represent the x4 and x8 tables
respectively:

unsigned short x8_raw_data[] = {
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
        0x0000, 0x0100, 0x0001, 0x0101, 0x01B8, 0x015C, 0x012E, 0x01C6, 0x0163,
        0x01FD, 0x0189, 0x019D, 0xB801, 0x5C01, 0x2E01, 0xC601, 0x6301, 0xFD01,
        0x8901, 0x9D01, 0x0200, 0x0002, 0x0202, 0x0201, 0x02B8, 0x025C, 0x02FD,
	....

The drawback with these is that they'll always be builtin, enlarging
kernel code by 10-15K although only one of them is in use.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

