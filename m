Return-Path: <linux-kernel-owner+w=401wt.eu-S935253AbXEVVyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253AbXEVVyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759829AbXEVVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:54:14 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:65349 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbXEVVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:54:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kqAJE21P9qcfKXer+nj4C+KCaP6usZW0GqOHOfkzhYO/qehaxUvXQTaW7/EVEhBDZhVpYn8jn2jBlaGWzc2QxMqt92LAGsPA7+TMd2btpRf7u83Y98gCrhduvWshvuAL89Ns7Wb0kWo0W6oPIClse5atIsOQqI7dFhVrSi4OcGU=
Message-ID: <524f69650705221454k7701cc72g45d4dcc3b535a33e@mail.gmail.com>
Date: Tue, 22 May 2007 16:54:12 -0500
From: "Steve French" <smfrench@gmail.com>
To: linux-kernel@vger.kernel.org, jra@samba.org,
       linux-cifs-client@lists.samba.org
Subject: Maximum kmem_cache_create size
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When using mm/slab.c the maximum size of kmem_cache_created objects
seems to be simply KMALLOC_MAX_SIZE.  Is it the same thing when using
the version of kmem_cache_create in mm/slub.c?

What are common values of this for different architectures?  On this
Intel (Core 2 T7600) system it shows up as 0x800000 which is larger
than I thought it used to be.

Now that Samba 3.0.26pre server supports larger than 128K read
operations, I wanted to be able to allow users to configure (at insmod
time for cifs.ko) the maximum read buffer size supported.  I wanted to
be able to set it to a smaller value during cifs_init_request_bufs if
they tried to set it explicitly to something over KMALLOC_MAX_SIZE but
want to make sure that this value applies no matter which version of
kmem_cache_create (slub vs. slab) that they use.

I realize that allocating larger objects could make read performance
worse (fortunately for most cases cifs write does not need to use
large buffers since it can send a page list)  so I am leaving the
default request buffer size the same (most servers prefer roughly
16K+sizeof header) - and in any case the RFC1001/1002 length field
only has room for 3 bytes (so 0x800000 is close to the maximum the
protocol would support anyway).

-- 
Thanks,

Steve
