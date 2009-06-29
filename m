Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZF2TfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZF2TfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZF2Tez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:34:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:50094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZF2Tey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=LPS2SJVFTuoAuqZOUHOUPks8zCHXbRRH6GkdH8gZB5XDH6zDUeo1IwU7aQ1xhCtoj8
         yEQmcvgi9amnNZQnTk9qBiiWzDBhmFT6xROAeXew8nANONtpkJ06HyAxtwlARuqh++SU
         1cYMDQ+rttyTyIUYROFFUNODT7RAf4A5Bg0Wg=
Message-ID: <4A49175E.3020409@gmail.com>
Date: Mon, 29 Jun 2009 21:34:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.5 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: sameo@linux.intel.com
CC: LKML <linux-kernel@vger.kernel.org>, laforge@openezx.org, drwyrm@gmail.com
Subject: MFD: mutex from ISR in ezx-pcap?
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

pcap_adc_irq tries to perform non-atomic operations in ISR which is not
allowed. Above that, it may deadlock.

Since all the operations there (read, write, mutex locking) may sleep,
any objections to convert the ISR contents to a workqueue?
