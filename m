Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZA1TDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZA1TDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZA1TDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:03:42 -0500
Received: from mx5.mail.ru ([194.67.23.25]:23877 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbZA1TDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:03:41 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] firmware: speed up request_firmware()
To: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2009 22:03:25 +0300
References: <20090128180446.GB31107@ovro.caltech.edu>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LSFhF-0002OC-00.arvidjaar-mail-ru@mx5.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ira Snyder wrote:

> 
> Without this patch, loading a 12MB firmware image (FPGA bitfiles) called
> vmalloc() approximately 3000 times. With the patch, vmalloc() is only
> called 13 times, however, some memory is wasted until firmware_release()
> is called. Usually, this happens very quickly, so it shouldn't be a
> problem.
> 

Some drivers cache firmware in memory. Doubing the amount of needed memory 
definitely would not be the best idea. Check drivers/net/wireless for 
examples.
