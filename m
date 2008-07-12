Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbYGLHne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbYGLHne (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYGLHn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:43:27 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:51007 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYGLHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VLEA6PF8+83NlvmVXCSvd7/7KQxWN8XvocnvsKSi+nXk2VPcLFWpRTHC3J/eVSmWvk
         xHB358fnLl4lhCYvmlFhX/y7DwBjMlLxm+WtCs3tlsnBDxZqZk4WNC9k4tR1zo6SX4C9
         W4PyncmSzvNB5QhQiajxS0+Rx7z4xgOTsks54=
Date: Sat, 12 Jul 2008 11:43:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: apic LVTT - use APIC_DIVISOR on 64bit mode
Message-ID: <20080712074322.GB7010@asus>
References: <20080709190237.GA21423@asus> <20080712060504.GB14714@elte.hu> <20080712072216.GA7010@asus> <20080712073910.GA10689@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080712073910.GA10689@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sat, Jul 12, 2008 at 09:39:10AM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > @@ -329,7 +332,7 @@ static void __init calibrate_APIC_clock(
| >  	 *
| >  	 * No interrupt enable !
| >  	 */
| > -	__setup_APIC_LVTT(250000000, 0, 0);
| > +	__setup_APIC_LVTT(4000000000, 0, 0);
| 
| note how close it is to 2^32. For this to be unifiable later on this 
| needs to be UL i guess, and this:
| 
| > -	calibration_result = result / HZ;
| > +	calibration_result = result * APIC_DIVISOR / HZ;
| 
| might overflow 32 bits.
| 
| 	Ingo
|

hmm... I need more time for analisys, thanks. Drop this patch
please
 
		- Cyrill -
