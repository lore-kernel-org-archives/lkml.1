Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYJTR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYJTR1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJTR1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:27:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:5411 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYJTR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=rtd7waOEbaaP2X1U1ikPB7alC4oLIEEKvaKNLlJG2ufYtJnAyYP/7JGXuUzvSfjI9R
         Cz31TA0qveoz1OMvFU4s1IFfZWM1hXpx+4gEeEzebzk3abEPZgD0U0q5Zqh+27dkkaDU
         tLCVkGQ1w1XUbhoSWVQ0hHdJLdEe0v00tTNQc=
From: Eric Lacombe <goretux@gmail.com>
To: avi@redhat.com
Subject: [x86] - technical questions about HV implementation on Intel VT
Date: Mon, 20 Oct 2008 19:27:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810201927.33580.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I worked on a particular hypervisor, that just put in a VM the currently 
running kernel. But I faced some problems and I would like to know some good 
practices in order to debug the module I develop.

When the module put the current kernel in "vmx non-root mode", some conditions 
irremediably trigger a VM-Exit (with the processor I use, loading cr3 always 
trigger a vmexit). And here comes my problem. How can I reliably get 
information (by way of printk) when my hypervisor screw something up, and 
crash the machine with lots of debug info that scroll quickly on the screen, 
just before freezing the machine.

In fact, It seems that in some situations the machine "loop on page faults".
Let me depict the scenario:
After a vmxlaunch, the host hand over the cpu to the guest then a vmexit 
occurs. Thus, the guest hand over to the host. the host checks some things 
and issue a vmxresume, and.. a vmexit occurs again, etc. etc.

So, when the host take control for the first time after the first vmexit, I 
would like the host to print informations and to "die correctly", so as I 
could read these information on the screen (ie, without being polluted with 
lots of debug messages that scroll on the screen).

Note: I already have some vmexits due to invalid guest state during vmxlaunch, 
but it seems (because my trivial printings for those situations do not show 
again) I fully repaired those problems. Now there is a lot of debug info 
quickly scrolling on the screen before the system crashes :/

Thanks in advance for your answers.

	Eric
