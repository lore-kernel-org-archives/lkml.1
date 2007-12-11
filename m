Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbXLKNLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbXLKNLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXLKNLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:11:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:14323 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXLKNLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding:from;
        b=Fzeev8LO02jadnTqzKg0+0enyr92vTnrBuHuggi6UAlOspQSSt24rM4sKT4KhvbGZFpFuM/r6td2HYHX18JSuxHmpZyksssquEcIUx8d32LvAIlrjQVBADaEjWmGoKHWtBwyt0OV2qmiyX7DVk9u1TWSmEwWgB+Ec2k7KZMVMaI=
Message-ID: <475E8C8B.7070308@qumranet.com>
Date: Tue, 11 Dec 2007 15:11:39 +0200
Reply-To: dor.laor@qumranet.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: mingo@elte.hu, tglx@linutronix.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Performance overhead of get_cycles_sync
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas,

In the latest kernel (2.6.24-rc3) I noticed a drastic performance 
decrease for KVM networking.
The reason is many vmexit (exit reason is cpuid instruction) caused by 
calls to gettimeofday that uses tsc sourceclock.
read_tsc calls get_cycles_sync which might call cpuid in order to 
serialize the cpu.

Can you explain why the cpu needs to be serialized for every gettime call?
Do we need to be that accurate? (It will also slightly improve physical 
hosts).
I believe you have a reason and the answer is yes. In that case can you 
replace the serializing instruction
with an instruction that does not trigger vmexit? Maybe use 'ltr' for 
example?

Regards,
Dor.
