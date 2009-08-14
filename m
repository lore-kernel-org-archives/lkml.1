Return-Path: <linux-kernel-owner+w=401wt.eu-S1755629AbZHNFAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbZHNFAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZHNFAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:00:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:58587 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbZHNFAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w6mTCalPJSG8JDzDCSv0HBhx88uUlku+MglwmsbYRFmKtejEC/Ozzo5RtYlbKOav1P
         kJZreTT/8xacS6Xv9KyJPgQfPMXyOiaquFcuskYTX/hMF/CGzLIYc7mlfS2jiPot5T/E
         wmvOG7296h5GaAhaUFmmxCyZ0Y9sz3qYjvhZk=
MIME-Version: 1.0
Date: Thu, 13 Aug 2009 21:52:59 -0700
Message-ID: <9ff7a3bc0908132152g694a2009r9007aed59428f892@mail.gmail.com>
Subject: bread problem
From: Joel Fernandes <agnel.joel@gmail.com>
To: linux-fs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I'm trying to read a block from disk by block_nr using __bread before
the block has even been written to disk.
The problem in doing this is the block is cached (junk data) and
future sb_bread's return the buffer head from this cache, and not one
that represent the actual data after this data has been written to
disk.

1. block contains junk
2. bread -> cached junk
3. actual data written to disk through the address space object hosted
by some other inode
4. bread -> still returns bh with junk

Is there any way to force a read from disk while doing the second
bread, or to instruct the kernel that the block that's in the cache
has to be re-read?

Thanks,
Joel
