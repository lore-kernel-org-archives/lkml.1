Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZA1Sfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZA1Sfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZA1Sfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:35:43 -0500
Received: from waste.org ([66.93.16.53]:34798 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZA1Sfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:35:42 -0500
Subject: Re: [PATCH] firmware: speed up request_firmware()
From: Matt Mackall <mpm@selenic.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ira Snyder <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090128181117.35fb319b@lxorguk.ukuu.org.uk>
References: <20090128180446.GB31107@ovro.caltech.edu>
	 <20090128181117.35fb319b@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 12:35:22 -0600
Message-Id: <1233167722.18091.2.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 18:11 +0000, Alan Cox wrote:
> > Without this patch, loading a 12MB firmware image (FPGA bitfiles) called
> > vmalloc() approximately 3000 times. With the patch, vmalloc() is only
> > called 13 times, however, some memory is wasted until firmware_release() is
> > called. Usually, this happens very quickly, so it shouldn't be a problem.
> 
> Particularly on 32bit x86 vmalloc memory space is very precious so while
> the current buffer size default may be too small doubling repeatedly is
> not a good model IMHO.

How about a small exponent like 1.1?

-- 
http://selenic.com : development and support for Mercurial and Linux


