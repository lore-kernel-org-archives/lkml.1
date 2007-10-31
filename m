Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXJaA7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXJaA7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXJaA7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:59:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:9556 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbXJaA7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rc3WJc1HOGDlryo75YoLH9n9pae2C0Cvf0kvzxTLBZoZA6XqbspeaeQKAIjPmTIeklFtoXtlP9kR3OpiBp56sJ6ZHPEy82EMbVbW1wFMO2ZjGb52cruceDq4uxspRYbteK+kjEe209UhBnvtqk22EhDbwvzJ7deTy8wBSgccEPE=
Message-ID: <f6ca9fed0710301759r3b99e24bw542a64d38af79faa@mail.gmail.com>
Date: Wed, 31 Oct 2007 01:59:34 +0100
From: dragoran <drago01@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [ipw3945-devel] iwl3945 in 2.6.24-rc1 dies under load
Cc: linux-wireless@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
In-Reply-To: <20071031005202.GA1534@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071031005202.GA1534@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, Pavel Machek <pavel@ucw.cz> wrote:
>
> Hi!
>
> ...does not seem to work too well :-(. It connects with the AP
> (good!), and survives some "normal" use, but it died at first big
> tcpspray (baaaad!).
>

> Oct 31 01:05:07 amd kernel: phy4: Selected rate control algorithm
> 'simple'
[..]
> Oct 31 01:23:53 amd kernel: iwl3945: iwl-3945-rs not selected as rate
> control algo!
[...]

the iwlXXXX driver do not work well with the simple rate scale algo.
make sure that its not built into the kernel and not loaded before
iwl3945 is loaded.
You can also try the patches from Johannes which fixes this by letting
the driver choose which one to use as default.
