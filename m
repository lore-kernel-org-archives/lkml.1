Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbXKFW5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbXKFW5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXKFW5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:57:13 -0500
Received: from ozlabs.org ([203.10.76.45]:46667 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXKFW5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:57:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: virtio config_ops refactoring
Date: Wed, 7 Nov 2007 09:57:43 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Avi Kivity <avi@qumranet.com>, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>
References: <4730A8F3.6020008@us.ibm.com>
In-Reply-To: <4730A8F3.6020008@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711070957.44165.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 04:48:35 Anthony Liguori wrote:
> Semantically, find requires that a field have both a type and a length.
> With the exception of the VIRTQUEUE field used internally by lguest,
> type is always a unique identifier.  Since virtqueue information is not
> a required part of the config space, it seems to me that type really
> should be treated as a unique identifier.

Hi Anthony,

	Not sure I get this.  It is a unique identifier.  You need the length
to handle unknown fields.

> find_vq also is curious in that it is stateful in it's enumeration.

Well, they're *all* stateful.  This gives a simple method of knowing what 
fields the guest understands: it marks the fields as it finds them.  Then it 
sets the status, which allows the host to know when it's completed 
configuration reads.

I like enumerating the virtqueues: it's not necessary but it's clearer.

> This adds seemingly unnecessary complexity.

I'd be happy for a simpler mechanism...

Cheers,
Rusty.
