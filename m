Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbYEVDix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbYEVDix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYEVDi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:38:27 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:36087 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756991AbYEVDi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:38:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6No9QQC+V2kdfSEkdeN8A6MmD4FhddbRQyq8q3fBLS79Q43eeTt6Yr7xFJ4vMtYpsHsUb0Bpuicb8d8bFg6V668crR90gbzODGuI8IbwOHHGvVoCQaPAvclCfVQi1K3NqzKBzwvGizt1dUDxNOdBxkiZkHfA1GmP2/XpW33N1c0=  ;
X-YMail-OSG: T_ir7VQVM1nCtGCxF8X9cXIpyG56Gj2pnzcxqZ1QBOGqzcQATbd.J4sSD5hI1ObjAJ3K_H8zthkDmGvpABq_HQa4EGdiZCQdEKuMn1JYxM50Q7joh.5b3e56Rbbo7SJ9yrU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/4] spi: split up spi_new_device() to allow two stage registration.
Date: Wed, 21 May 2008 17:17:13 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, fabrizio.garetto@gmail.com,
       jonsmirl@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516193608.28030.34968.stgit@trillian.secretlab.ca>
In-Reply-To: <20080516193608.28030.34968.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805211717.13206.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008, Grant Likely wrote:
> 
> This patch splits the allocation and registration portions of code out
> of spi_new_device() and creates three new functions; spi_alloc_device(),
> spi_register_device(), and spi_device_release(). 

I have no problem with the first two, but why the last?

If the devices are always allocated by spi_alloc_device() as
they should be -- probably through an intermediary -- the
only public function necessary for that cleanup should be
the existing spi_dev_put().

- Dave
