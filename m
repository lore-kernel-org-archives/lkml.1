Return-Path: <linux-kernel-owner+w=401wt.eu-S1764110AbZDANOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764110AbZDANOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZDANO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:14:29 -0400
Received: from pc125.solomon-systech.com ([202.76.106.125]:57817 "HELO
	virus-gateway.solomon-systech.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753570AbZDANO3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:14:29 -0400
X-Greylist: delayed 3631 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 09:14:28 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: mmc removal and file system access mutex
Date: Wed, 1 Apr 2009 20:15:37 +0800
Message-ID: <6334E09627481B4AA5C8DE1E69E19D3B0C1FF8A6@SSLEXCHANGE.solomonsystech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: mmc removal and file system access mutex
Thread-Index: Acmyw1NNPJGJVKVoRCWHQnH7pabVhg==
From: <sasin@solomon-systech.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running into crashes/hangs when repeatedly removing/reinserting an
MMC card while reading a file on the card.  The card is automatically
unmounted on removal and remounted on insertion at the same mount point.

The hang was caused by elv_next_request in mmc_request repeatedly
presenting the same request on a dead queue.  The crash is caused by the
file system read track accessing the freed request queue or some other
structure element associated with the block device that was removed.
Isn't there some form of mutex preventing this?

I am using 2.6.24 on ARM926 - sorry for using such an outdated version
:-(

Best regards,
Sasi
