Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbXEPSDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbXEPSDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXEPSDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:03:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:13854 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763112AbXEPSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RbiCS48/APZ6jtv016bIhIuypir9aTrAKCLrWK6HuVC+8jL8U1QCOPyzrRNQV93t1FoJruMQrXtfva67P4fc5ReWQMlQC7P2ziBoCqp9B3dADWcbAHFnhH7x5TnU29yjo/ILlO/w1AkETi7sHm1eBwLmSdyyIv1bOSMezu4EBSM=
Message-ID: <feeb478c0705161103idf7b577t4e6011ec506f1747@mail.gmail.com>
Date: Wed, 16 May 2007 13:03:45 -0500
From: "Alan Miller" <pushingthecharacterlimit@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: dm-crypt: disabling barriers, data corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 2.6.19, dm-crypt passes write barrier requests through to the
underlying device in the order received unmodified (the ordering).

In 2.6.19 and newer, these writes are now passed through a workqueue.
On an SMP box running encrpytion for write requests in parallel,
wouldn't this cause the requests to arrive to the device in a
different order?  A 2.6.22 patch from Milan Broz sets dm-crypt to
disable barriers, but if this disabling is being handled at the
filesystem level, is there still a chance of data becoming corrupt?

I'm currently running an unpatched 2.6.20 kernel on an SMP machine
testing the validity of some static files going back and forth through
dm-crypt on an XFS filesystem mounted with nobarrier to be sure, and
so far I'm not noticing anything, but this is hardly a good test.
Suggestions or any other way to help out appreciated.
