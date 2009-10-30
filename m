Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZJ3NRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZJ3NRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 09:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZJ3NRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 09:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397AbZJ3NRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 09:17:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4AE7ECC2.8050202@orcon.net.nz>
References: <4AE7ECC2.8050202@orcon.net.nz>
To: Michael Cree <mcree@orcon.net.nz>
Cc: dhowells@redhat.com, linux-alpha@vger.kernel.org,
       linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Re: Alpha: suspicious compiler warning in entry.S
Date: Fri, 30 Oct 2009 13:16:59 +0000
Message-ID: <5962.1256908619@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Cree <mcree@orcon.net.nz> wrote:

> On the assumption that it is important to include the TIF_NOTIFY_RESUME bit
> one might be tempted to modify the code to:
> 
>    lda    $2, _TIF_WORK_MASK
>    and    $5, $2, $2
> 
> but this is time critical code.  I am wondering whether it might be better
> to rearrange the bits in the thread information flags so that _TIF_WORK_MASK
> has a value less than 255 and the single instruction to perform an and
> operation can be maintained.

Unless the LDA can be interleaved around some memory accesses, then yes,
compressing _TIF_WORK_MASK would be good.

David
