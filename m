Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZDFNFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZDFNFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZDFNFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:05:42 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64574 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZDFNFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:05:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=xD24igfP8qAkD0729CjoewybfXfGecG6PQALxZiXX6B+4yTyAKuX2TMxzRt2snt3i/
         +qRr+sm57BaQg/SMcTIoCgFdfo2qncja1A0YgQyzeS7ZH9ggeSwUIJzL+xEKrxBrA2Od
         sgx0pbxagg7Sq89koQJdPGwyS3shyhNbe/VSg=
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 14:05:39 +0100
Message-ID: <87a5b0800904060605i3295b9c6m34daf0d4872ebe58@mail.gmail.com>
Subject: Commit f520360d93cdc37de5d972dac4bf3bdef6a7f6a7 may break hotplug
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

This commit changes the behaviour when calling the hotplug helper from
UMH_WAIT_EXEC to UMH_NO_WAIT. Unfortunately this seems to be causing
occasional segfaults for me. I believe this is caused because the argv
passed to call_usermode_helper is allocated on the stack and so may be
overwritten by the time the actual exec occurs.

Would it be possible to get this commit reverted?

Thanks,
