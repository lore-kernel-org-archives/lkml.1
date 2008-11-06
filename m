Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbYKFEeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbYKFEeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYKFEed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:34:33 -0500
Received: from kroah.org ([198.145.64.141]:36304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751504AbYKFEec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:34:32 -0500
Date: Wed, 5 Nov 2008 20:32:35 -0800
From: Greg KH <greg@kroah.com>
To: Yu Zhao <yu.zhao@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 16/16 v6] PCI: document the new PCI boot parameters
Message-ID: <20081106043235.GA30292@kroah.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084531.GP3773@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022084531.GP3773@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 04:45:31PM +0800, Yu Zhao wrote:
> Document the new PCI[x86] boot parameters.
> 
> Cc: Alex Chiang <achiang@hp.com>
> Cc: Grant Grundler <grundler@parisc-linux.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> 
> ---
>  Documentation/kernel-parameters.txt |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 53ba7c7..5482ae0 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1677,6 +1677,16 @@ and is between 256 and 4096 characters. It is defined in the file
>  		cbmemsize=nn[KMG]	The fixed amount of bus space which is
>  				reserved for the CardBus bridge's memory
>  				window. The default value is 64 megabytes.
> +		assign-mmio=[dddd:]bb	[X86] reassign memory resources of all
> +				devices under bus [dddd:]bb (dddd is the domain
> +				number and bb is the bus number).
> +		assign-pio=[dddd:]bb	[X86] reassign io port resources of all
> +				devices under bus [dddd:]bb (dddd is the domain
> +				number and bb is the bus number).
> +		align-mmio=[dddd:]bb:dd.f  [X86] relocate memory resources of a
> +				device to minimum PAGE_SIZE alignment (dddd is
> +				the domain number and bb, dd and f is the bus,
> +				device and function number).

This seems like a big problem.  How are we going to know to add these
command line options for devices we haven't even seen/known about yet?

How do we know the bus ids aren't going to change between boots (hint,
they are, pci bus ids change all the time...)

We need to be able to do this kind of thing dynamically, not fixed at
boot time, which seems way to early to even know about this, right?

thanks,

greg k-h
