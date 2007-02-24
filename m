Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXBXLuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXBXLuE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbXBXLuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:50:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:22248 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXBXLuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CEH2HmnwGwMssPpTztV2/NgF55jASB9yO3rhKIIjH8kOhTu1FNHBCvZgqiWXohZIAYL1FQocs2D3hSmcwFyKQVEILkmBzu6wYabndYg/s0Q7ugu5Txb2aTN5/b5uTlsZpvnJ8G9FeDCMZVB8Km9+1TI6N9/iXZHkQ7K6kBogW7Y=
Message-ID: <1eff86fb0702240350l2c111c2apb5639fec67b360b4@mail.gmail.com>
Date: Sat, 24 Feb 2007 11:50:00 +0000
From: "Stephen Dolan" <stedolan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Memory sharing question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I'd like to know if it is possible to get two processes to share a
memory segment at the same address, e.g. both mmap() the same file and
have it return the same address in both.

This could be done by mmap()ing it in one of them, communicating the
address to the other (via a socket or whatever), which then mmap()s it
with the address as the "start" parameter and MAP_FIXED. However, that
tends to fail, and MAP_FIXED can have annoying side-effects (killing
off other mappings).

Is it possible to reliably make the same address in two different
processes point to the same bit of physical memory?

The point of all this is that I want to pass a large, complex (full of
pointers) data structure to a different process, and I don't want the
overhead of serialising it down a socket and then parsing it at the
other end (the data structure's pretty big, and the other process
won't need it all). Is this possible?

Thanks,
Stephen Dolan
