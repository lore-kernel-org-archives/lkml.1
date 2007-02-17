Return-Path: <linux-kernel-owner+w=401wt.eu-S1946326AbXBQADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946326AbXBQADO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 19:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946320AbXBQADO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 19:03:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:16779 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946330AbXBQADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 19:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Czsn7C/bP4TFJeiKG9ul7rXG6FoUniU/YN0j9n0EFtgXU9hASRZ3tLDlsMl/3RRd8T2c7W0iowNst1u/iAjJO+ZclEKo/xSnJMZdQSd02fTDcsIP9ybhT7qfj+CmmWiKFzNle+PxLO824liEBFHf+u42yYNgSe7/QmXujjiL8iU=
Subject: [kj][RFC] roll macro's in bitops.h
From: "Darren Jenkins\\" <darrenrjenkins@gmail.com>
To: kernel Janitors <kernel-janitors@lists.osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 11:02:51 +1100
Message-Id: <1171670571.7850.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

G'day people,

I was looking at bitops.h and noticed there were a couple of inline roll
functions to operate on 32bit variables. (left and right)

I think that is a little bit dumb as they are constant width (only
32bits) due to it being an inline function, and was wondering if anyone
thought it would be useful to have some (variable sized) roll macros
instead.

I whipped these twp up as examples, but have not tested them yet.

#define RollRight(Data, Distance) \
({      typeof(Data) __a = Data;   \
        typeof(Distance) __b = Distance%(sizeof(__a) * 8); \
	__a = ((__a>>__b) | (__a<<((sizeof(__a) * 8) - __b))) \
	__a; \
})

#define RollLeft(Data, Distance) \
({      typeof(Data) __a = Data;   \
        typeof(Distance) __b = Distance%(sizeof(__a) * 8); \
	__a = ((__a<<__b) | (__a>>((sizeof(__a) * 8) - __b))) \
	__a; \
})

Also if these are useful I was wondering how to handle the existing
functions ? #define them out for the time being ?

#define rol32(a, b) RollLeft(a, b)
#define ror32(a, b) RollRight(a, b)




Darren Jenkins


