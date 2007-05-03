Return-Path: <linux-kernel-owner+w=401wt.eu-S1162001AbXECObK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162001AbXECObK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162008AbXECObK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:31:10 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:26143 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162001AbXECObJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:31:09 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Thu, 03 May 2007 15:30:55 +0100
Subject: Re: netfront for review
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <C25FB0AF.E59B%keir@xensource.com>
Thread-Topic: netfront for review
Thread-Index: AceNj6h95yRDcPmCEduMigAX8io7RQ==
In-Reply-To: <4639F16C.3090005@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On 3/5/07 15:27, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>> The function has an effect in page flipping mode only.  It walks the
>> whole list of rx skbufs (id is the loop variable ...), checks whenever
>> they are handed out to the frontend driver to fill in packet data and
>> not returned yet, and if so reclaim them ...
> 
> Yes, but why use add_id_to_freelist?  rx_skbs are not being used on a
> freelist anywhere else.  It just means the rx_skb array gets filled with
> small integers, but the rest of the code assumes they're either NULL or
> an skb pointer.

The need for it went away when Herbert Xu made the mapping between
receive-ring slots and receive-request/response identifiers static. I think
there was a race between Gerd writing his patch, Herbert removing the need
for add_id_to_freelist, and Gerd's patch being checked in.

 -- Keir

