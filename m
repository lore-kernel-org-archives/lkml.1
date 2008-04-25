Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbYDYVtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbYDYVtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 17:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbYDYVtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 17:49:06 -0400
Received: from outbound-mail-105.bluehost.com ([69.89.18.5]:53042 "HELO
	outbound-mail-105.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756162AbYDYVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 17:49:06 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz, yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] pci/irq: restore mask_bits in msi shutdown -v3
Date: Fri, 25 Apr 2008 14:48:21 -0700
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "David Miller" <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
       "Greg KH" <greg@kroah.com>, "Jeff Garzik" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
References: <200804222148.17530.yhlu.kernel@gmail.com> <200804231456.30786.yhlu.kernel@gmail.com>
In-Reply-To: <200804231456.30786.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804251448.21966.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.88.206.99 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2008 2:56 pm Yinghai Lu wrote:
> Yinghai found after using 2.6.25-rc3 later to kexec RHEL 5.1,
> NIC can not be used.
>
> bisected to

Hi Yinghai, I've been thinking about these patches a bit...  They seem like an 
important bug fix (making sure kexec'd kernels work), but I'm a bit worried 
that the kexec'd kernel can't handle potentially broken MSI/INTx setups.  
Shouldn't the kexec'd kernel be a bit more robust?  I guess in this case 
you're kexec'ing an old kernel, so there's not much we can do, but it still 
makes me a little uneasy.

I guess for this particular set it doesn't matter much, since we should be 
restoring things in pci_msi*_shutdown and pci_shutdown_device either way.  
Can you clean up the changelog a bit and maybe make it more concise?  E.g. we 
probably don't need the whole commit message for the bisect, and we want to 
be clearer about what the failure mode is w/o the changes...

Thanks,
Jesse
