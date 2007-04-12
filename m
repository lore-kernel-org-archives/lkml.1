Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXDLTj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXDLTj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXDLTj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:39:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:19943 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbXDLTjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hbmc/bj2kcqc4s8nZvAO+PbzY4LUJ9kquMOmsJDjWvTQvvZh7PcDXb4UU9YyA9sAvMk8NHJuKXpNiFmiOYSeaVroHC2dvWRc09NA6hjnfc1w2YoCDMSqaxrNCcOY1qDIuil50vKsjFUyENILzepbCJywtkAMK18txqJjflEVofE=
Message-ID: <38b2ab8a0704121239sd848440t6ed23d71dc68798c@mail.gmail.com>
Date: Thu, 12 Apr 2007 21:39:24 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [CRYPTO] is it really optimized ?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After reading the crypto code and trying to implement a AES driver,
I'm wondering if the current  implementation is optimum. My plan is to
use _exclusively_ the AES driver to encrypt filesystems by using
eCryptfs for example.

But it seems that because the current implementation of the crypto
core allows the drivers to be accessed by any part of the kernel at
any time, that forces the AES driver to do extra works for each block
ciphering: mainly they are (a) set the key in AES controller (b)
generate the decryption key if in decrypt mode.

So is this interpretation right ? If so wouldn't it be appropriate to
introduce a mechanism to reserve this AES hardware for a special
purpose (filesystem encryptions) and thus make it as fast as possible
?

Thanks
-- 
Francis
