Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYHFNTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYHFNTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYHFNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:19:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43452 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYHFNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:19:22 -0400
Date: Wed, 6 Aug 2008 07:19:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Horman <horms@verge.net.au>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [patch] PCI: check the return value of device_create_bin_file() in pci_create_bus()
Message-ID: <20080806131900.GI2055@parisc-linux.org>
References: <20080805101605.GA19382@verge.net.au> <1217932416.7758.4.camel@localhost> <20080805101605.GA19382@verge.net.au> <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net> <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au> <20080805112814.GO26461@parisc-linux.org> <20080805121531.GA29763@verge.net.au> <20080805122639.GP26461@parisc-linux.org> <20080806005718.GE32143@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806005718.GE32143@verge.net.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:57:21AM +1000, Simon Horman wrote:
> Check the return value of device_create_bin_file in pci_create_bus and
> unwind if necessary. Don't propagate error to caller, as failure to create
> these files shouldn't prevent PCI from being initialised.

Much better ... one nit though:

>  static void pci_create_legacy_files(struct pci_bus *b)
>  {
[...]
> +
> +	return 0;

I'm sure the compiler warns about that.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
