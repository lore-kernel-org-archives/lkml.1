Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbYGHTxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbYGHTxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYGHTwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:52:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:42598 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYGHTwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:52:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=k/oUAHLwmlp4ZVLOgXphkPeFDB+nhWumLBcZHN8Ma9uboRgsyeh2LgVz0m+dPzaSgx
         FjYtxXBOsrsetoNb2SqrkHRlVNZgzUw3bLt2J1lGf1p4wdYURAvROiCEx6Q3f/yn4/+6
         jzkcfzcoN3GU+WzM6gi1VhFWwBssAJJcv9Q94=
Message-ID: <38b2ab8a0807081252v1bd5a2e5xc7c384704c0ae9e6@mail.gmail.com>
Date: Tue, 8 Jul 2008 21:52:53 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Trying to use splice from a driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to implement splice ops in a driver, specially the
splice_read method.

Basically the driver receives data and splice them to a pipe in order to
finally move the data to a file.

Before receiving the data, the driver allocates a free page by calling
alloc_page(). Then it fills it with the data received by the device and
then stores the page ref in the splice_pipe_desc structure. Once the
structure is initialised the driver calls splice_to_pipe.

Now the question is what am I supposed to use for pipe_buf_operations in
the splice_pipe_desc structure ?

I'm tempted to use 'user_page_pipe_buf_ops' but I'm not sure.  Specially
for the release method, which points to page_cache_pipe_buf_release(),
since the allocated page (the os allocated by the driver) are not coming
from the page cache.

The same is actually true for vmsplice() where the pages are coming from
the user mem space (not from the page cache), so I'm probably missing
something...

Could aynbody enlight me ?

thanks,
-- 
Francis
