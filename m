Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbYF1PJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbYF1PJa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYF1PJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:09:22 -0400
Received: from smtp.fullrate.dk ([89.150.129.5]:64156 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYF1PJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:09:21 -0400
Message-ID: <4866541F.1060709@agner.org>
Date: Sat, 28 Jun 2008 17:09:19 +0200
From: Agner Fog <agner@agner.org>
Organization: agner@agner.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org>	<20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com>	<4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org>	<4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org>
In-Reply-To: <87myl5pyqo.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
 >If a x86 device driver doesn't use the standard kernel interfaces for 
saving/restoring extended state
 > (kernel_fpu_begin/end) it will die.That is because Linux uses lazy 
FPU saving by default and when the
 >lazy FPU exception hits kernel code it will crash because that's not 
allowed. And the standard interfaces
 >are going to handle all extended state supported by the kernel. Full 
XSAVE support should be there for
 > 2.6.27.

Thank you Andi. Finally an exact and exhaustive answer. :-)
This info is not in the "Unreliable Guide To Hacking The Linux Kernel" 
or anywhere else except deeply hidden in the archives of this mailing 
list. I had to actually look into the source code of kernel_fpu_begin to 
verify that it saves not only the FPU but also the XMM registers and 
that it disables pre-emption.

You see why I want proper documentation? If this had been documented in 
some reference that was easy to find, I wouldn't have needed to take 
your time with all these questions...

Note: Please Cc: me of answers.
