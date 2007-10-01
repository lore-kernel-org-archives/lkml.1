Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXJAS5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXJAS5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXJAS45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:56:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57956 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXJAS45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:56:57 -0400
Date: Mon, 1 Oct 2007 12:56:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-pcmcia@lists.infradead.org, Dominik Brodowski <linux@brodo.de>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify yenta code
Message-ID: <20071001185655.GM12049@parisc-linux.org>
References: <20071001184115.GB4338@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001184115.GB4338@austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 01:41:15PM -0500, Linas Vepstas wrote:
> -	if (type & IORESOURCE_IO) {
> -		if ((yenta_search_res(socket, res, BRIDGE_IO_MAX)) ||
> -		    (yenta_search_res(socket, res, BRIDGE_IO_ACC)) ||
> -		    (yenta_search_res(socket, res, BRIDGE_IO_MIN)))
> -			return 1;
> -	} else {
> -		if (type & IORESOURCE_PREFETCH) {
> -			if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
> -			    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
> -			    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))
> -				return 1;
> -			/* Approximating prefetchable by non-prefetchable */
> -			res->flags = IORESOURCE_MEM;
> -		}
> +	if ((yenta_search_res(socket, res, BRIDGE_MEM_MAX)) ||
> +	    (yenta_search_res(socket, res, BRIDGE_MEM_ACC)) ||
> +	    (yenta_search_res(socket, res, BRIDGE_MEM_MIN)))

Are BRIDGE_IO_MAX and BRIDGE_MEM_MAX guaranteed to be the same?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
