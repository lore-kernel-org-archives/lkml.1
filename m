Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZBMVOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZBMVOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZBMVNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:13:52 -0500
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:42088 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752141AbZBMVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:13:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DufSmepdqc04KxC7ghQ1qW6C8h6dv4yOPdMBF4FPe52lMjhalO3LEJXZgbfL8YtHTSTwqz1IYG6s4OMKuXyQDSDbMEE44OvPmvQugttSs46c4aoAdXwBEnWUHc1rIuBf;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] pci/msi: Use #ifdefs instead of weak functions
Date: Fri, 13 Feb 2009 13:13:47 -0800
User-Agent: KMail/1.9.10
Cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linuxppc-dev@ozlabs.org
References: <d1c931db79adf22f3506aa0343aec5361600b37e.1232325038.git.michael@ellerman.id.au>
In-Reply-To: <d1c931db79adf22f3506aa0343aec5361600b37e.1232325038.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131313.48615.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 18, 2009 4:31 pm Michael Ellerman wrote:
> Weak functions aren't all they're cracked up to be. They lead to
> incorrect binaries with some toolchains, they require us to have empty
> functions we otherwise wouldn't, and the unused code is not elided
> (as of gcc 4.3.2 anyway).
>
> So replace the weak MSI arch hooks with the #define foo foo idiom. We no
> longer need empty versions of arch_setup/teardown_msi_irq().
>
> This is less source (by 1 line!), and results in smaller binaries too:
>
>    text	   data	    bss	    dec	    hex	filename
> 9354300	1693916	 678424	11726640 b2ef30	build/powerpc/vmlinux-before
> 9354052	1693852	 678424	11726328 b2edf8	build/powerpc/vmlinux-after
>
> Also smaller on x86_64 and arm (iop13xx).
>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Applied to my linux-next branch, thanks Michael.


-- 
Jesse Barnes, Intel Open Source Technology Center
