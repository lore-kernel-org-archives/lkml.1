Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZAOBo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZAOBo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZAOBoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:44:18 -0500
Received: from mail.crca.org.au ([67.207.131.56]:41185 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZAOBoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:44:17 -0500
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 20:44:17 EST
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] [PATCH] resume: wait for device probing to finish
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200901150039.58972.rjw@sisk.pl>
References: <200901142303.46166.rjw@sisk.pl>
	 <20090114152444.64e1ddfb.akpm@linux-foundation.org>
	 <200901150039.58972.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Thu, 15 Jan 2009 12:34:36 +1100
Message-Id: <1231983276.7229.575.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael etc.

On Thu, 2009-01-15 at 00:39 +0100, Rafael J. Wysocki wrote:

[...]
 
>  /**
> + * wait_for_device_probe
> + * Wait for device probing to be completed.
> + *
> + * Note: this function polls at 100 msec intervals.
> + */
> +int wait_for_device_probe(void)
> +{
> +	/* wait for the known devices to complete their probing */
> +	while (driver_probe_done() != 0)
> +		msleep(100);
> +	async_synchronize_full();
> +	return 0;
> +}
> +

Am I missing something? I can't see why you're polling instead of using
probe_waitqueue.

Regards,

Nigel

