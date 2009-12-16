Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbZLPHO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbZLPHO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933346AbZLPHOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:14:52 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:20559
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933607AbZLPHOv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:14:51 -0500
X-SpamScore: -47
X-BigFish: VPS-47(z21eWz1432R98dN936eMzz1202hzz5eeeTz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUQHG8-01-BTG-02
X-M-MSG: 
Date: Wed, 16 Dec 2009 08:14:43 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: K8 ECC error with linux-2.6.32
Message-ID: <20091216071443.GA18814@aftab>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912150808.04814.johannes.hirte@fem.tu-ilmenau.de>
 <20091215153026.GD20880@aftab>
 <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Dec 2009 07:14:31.0974 (UTC) FILETIME=[69ED8460:01CA7E1F]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:

>
> This patch (as the BIOS option) will only disable the error reports. The error 
> itself will still occur, right? So necessary to find out why the radeon driver 
> trigger this error.

Because the graphics driver does aperture accesses with no
matching GART translation, and the hw generates mchecks for
that. The whole story on GART table walk errors is in section
"13.10.1 GART Table Walk Error Reporting" in the document here:
http://support.amd.com/us/Processor_TechDocs/32559.pdf

I can't say for sure about your BIOS, but if it is done as described in
the abovementioned section, the BIOS option should disable logging of
the error, which implies reporting too.

The patch is still needed for machines that do not have that BIOS
option.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

