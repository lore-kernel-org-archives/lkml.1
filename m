Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbZIROK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbZIROK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZIROKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:10:55 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:52046 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZIROKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:10:55 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R1453M98dN936eM4015La4a4kzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ67DR-04-3LH-02
X-M-MSG: 
Date: Fri, 18 Sep 2009 16:10:43 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Keith Mannthey <kmannth@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [Patch] AMD64_EDAC:  simple fix to allow better report on ECE
 CE errors
Message-ID: <20090918141043.GC25309@aftab>
References: <1253239779.7263.111.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253239779.7263.111.camel@keith-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Sep 2009 14:10:38.0175 (UTC) FILETIME=[CC2DB6F0:01CA3869]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Thu, Sep 17, 2009 at 07:09:39PM -0700, Keith Mannthey wrote:
> I tested 2.6.31 and the mainline amd64_edac driver. This is was the
> first simple fix.  
> 
> This allows the errors to be further decoded and mapped to csrows. 
> Tested with ECC debug dimms and an Rev F cpu based system. 
> 
> Submitted-by:  Keith Mannthey<kmannth@us.ibm.com>

Thanks, applied. By the way, the tagging is not 'Submitted-by' but
'Signed-off-by' - I've corrected it accordingly. Please consult
<Documentation/SubmittingPatches> for more details on how to prepare
your patches.

> --- 
> 
> diff -urN linux-2.6.31/drivers/edac/amd64_edac.c linux-2.6.31-fixed/drivers/edac/amd64_edac.c

Add the -p option when creating the diffs so that it is visible which
function you're editing.

> --- linux-2.6.31/drivers/edac/amd64_edac.c	2009-09-09 15:13:59.000000000 -0700
> +++ linux-2.6.31-fixed/drivers/edac/amd64_edac.c	2009-09-17 22:32:09.000000000 -0700
> @@ -1136,7 +1138,7 @@
>  	 * different from the node that detected the error.
>  	 */
>  	src_mci = find_mc_by_sys_addr(mci, SystemAddress);
> -	if (src_mci) {
> +	if (!src_mci) {
>  		amd64_mc_printk(mci, KERN_ERR,
>  			     "failed to map error address 0x%lx to a node\n",
>  			     (unsigned long)SystemAddress);
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

