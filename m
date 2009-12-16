Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZLPQmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZLPQmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbZLPQmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:42:04 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:11191 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZLPQmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:42:00 -0500
X-SpamScore: -58
X-BigFish: VPS-58(z21eWz1432R98dN936eM148cM179dNzz1202hzz5eeeTz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KUR7PJ-02-AXP-02
X-M-MSG: 
Date: Wed, 16 Dec 2009 17:41:56 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
CC: linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error
 with linux-2.6.32)
Message-ID: <20091216164156.GF11618@aftab>
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de>
 <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de>
 <20091216071443.GA18814@aftab>
 <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Dec 2009 16:41:43.0370 (UTC) FILETIME=[A63872A0:01CA7E6E]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 03:58:30PM +0100, Johannes Hirte wrote:
> Am Mittwoch 16 Dezember 2009 08:14:43 schrieb Borislav Petkov:
> > On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:
> > > This patch (as the BIOS option) will only disable the error reports. The
> > > error itself will still occur, right? So necessary to find out why the
> > > radeon driver trigger this error.
> > 
> > Because the graphics driver does aperture accesses with no
> > matching GART translation, and the hw generates mchecks for
> > that. The whole story on GART table walk errors is in section
> > "13.10.1 GART Table Walk Error Reporting" in the document here:
> > http://support.amd.com/us/Processor_TechDocs/32559.pdf
> > 
> > I can't say for sure about your BIOS, but if it is done as described in
> > the abovementioned section, the BIOS option should disable logging of
> > the error, which implies reporting too.
> > 
> > The patch is still needed for machines that do not have that BIOS
> > option.
> 
> Disabling in BIOS doesn't made any difference. The errors were still reported. 

Hmm. It would be interesting to know what the BIOS does exactly
on your machine. We could easily find that out by installing the
x86info tool (either prepackaged for your distro or from here:
git://git.choralone.org/git/x86info) and doing as root:

lsmsr MC4 -V3

and sending me the output. Make sure the amd64_edac module is not loaded.

> Your patch disabled it.

Thanks for testing.

> But I think this will make work harder for driver developers as
> they won't get this error anymore. Could this be made changeable on
> runtime/boottime?

yep, we have that. You have to set 'report_gart_errors' module parameter
to 1 when loading amd64_edac and GART TLB errors will be reported.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

