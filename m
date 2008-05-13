Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbYEMEOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbYEMEOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 00:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYEMEOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 00:14:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33908
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbYEMEOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 00:14:08 -0400
Date: Mon, 12 May 2008 21:14:02 -0700 (PDT)
Message-Id: <20080512.211402.33040026.davem@davemloft.net>
To: Graf.Yang@analog.com
Cc: marcel@holtmann.org, cooloney@kernel.org, samuel@sortiz.org,
       irda-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [net/irda]: Fix a misalign access issue.
From: David Miller <davem@davemloft.net>
In-Reply-To: <0F1B54C89D5F954D8535DB252AF412FA0164BC89@chinexm1.ad.analog.com>
References: <1210588521-11508-1-git-send-email-cooloney@kernel.org>
	<1210598108.16390.47.camel@violet.holtmann.net>
	<0F1B54C89D5F954D8535DB252AF412FA0164BC89@chinexm1.ad.analog.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yang, Graf" <Graf.Yang@analog.com>
Date: Tue, 13 May 2008 12:07:35 +0800

> I have tried
> struct irda_device_info {
>         __u32       saddr;    /* Address of local interface */
>         __u32       daddr;    /* Address of remote device */
>         char        info[22]; /* Description */
>         __u8        charset;  /* Charset used for description */
>         __u8        reserve;  /* For align data */ 
>         __u8        hints[2]; /* Hint bits */
> };
> 
> It works with my irda driver. Can I modify it like this?

This header file and the irda_device_info datastructure are exported
to, and used by, userspace.

Therefore you cannot change this structure's layout without breaking
every single existing IRDA binary out there.
