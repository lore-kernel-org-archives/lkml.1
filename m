Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbYETVRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbYETVRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762692AbYETVRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:17:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41733
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758295AbYETVRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:17:36 -0400
Date: Tue, 20 May 2008 14:17:31 -0700 (PDT)
Message-Id: <20080520.141731.99514303.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] byteorder: eliminate pointer bytorder api
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211311449.5915.195.camel@brick>
References: <1211311449.5915.195.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Tue, 20 May 2008 12:24:09 -0700

> Not a great api, should be using cpu_to_etc and deref the pointer yourself.
> cpu_to_le16p
> cpu_to_le32p
> cpu_to_le64p
> cpu_to_be16p
> cpu_to_be32p
> cpu_to_be64p
> 
> Replaced by the aligned get_/put_ helpers
> le16_to_cpup
> le32_to_cpup
> le64_to_cpup
> be16_to_cpup
> be32_to_cpup
> be64_to_cpup
> 
> Also add const to the get/put helpers and use them in the access_ok case for
> unaligned access.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

But what you're doing in the first patch is killing performance for some
cases.

The reason we use the cpu_to_*p() interfaces is to get the other-endian
load and store instructions some processors have.

What you're doing is undoing all of that work we've done to take
advantage of such things.
