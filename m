Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbXIRR4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbXIRR4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbXIRRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:55:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:42603 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbXIRRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=WAUT6+MldcYdJmLzWvAokajmqTPMSwFnHYNvWzKLvxBw1VdXcMCOg7vYCmABInmM7Q/Vi5j59O3YyK/sQFhM7ZtOowuQhcwTXSLyouM1VHcOaEsGeCVGtKh6D7gSHPyqHwiCq5jccVHAp2kcPTuyoiUzZbIfyM6vCJEiXvxqx5U=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: bnx2 dirver's firmware images
Date: Tue, 18 Sep 2007 18:55:37 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
References: <200709181823.26429.vda.linux@googlemail.com> <1190141114.9540.216.camel@dell>
In-Reply-To: <1190141114.9540.216.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181855.37598.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 19:45, Michael Chan wrote:
> We can compress all the different sections of the firmware.  Currently,
> we only compress the biggest chunks and the rest are uncompressed.

> These zeros should compress to almost nothing.  But I agree that the
> firmware is still big.

You don't need to store and fetch zeros at all. You *know* that
they are zeros, right? So do this:

-                         REG_WR_IND(bp, offset, fw->bss[j]);
+                         REG_WR_IND(bp, offset, 0);

--
vda
