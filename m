Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZJAJCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZJAJCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbZJAJCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:02:00 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:56665 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZJAJB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:01:59 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Thu, 1 Oct 2009 11:00:48 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-prerelease; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291531.23389.borntraeger@de.ibm.com> <20090930171321.GA17200@amit-x200.redhat.com>
In-Reply-To: <20090930171321.GA17200@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011100.48087.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 30 September 2009 19:13:21 schrieb Amit Shah:
> - uses port->id instead of a static hvc_vtermno to pass on a value to
>   hvc_alloc(). Motivation explained within comments in the code.

[...]
> +	 * The first argument of hvc_alloc() is the virtual console
> +	 * number. hvc_alloc() checks if a console with the same value
> +	 * was used in hvc_instantiate(). We may not end up passing
> +	 * the same value here (we use the value 0 in
> +	 * hvc_instantiate() but the console port may not be at id
> +	 * 0). This isn't a problem, though. Nothing in hvc really
> +	 * depends on these numbers and since this number is passed on
> +	 * to us when cons_get/put_chars() is called, it's preferable
> +	 * to pass on the port->id so that we can get the port struct
> +	 * via get_port_from_id().
[...]
> +	port->hvc = hvc_alloc(port->id, 0, &virtio_cons, PAGE_SIZE);

I am not sure if this is going to be ok. 

When I change the old code (without your patch) to use vtermno=0 in 
hvc_instantiate and vtermno=1 in hvc_alloc I get 
"Warning: unable to open an initial console."

It seems to me that we have to pass the same values.

Christian
