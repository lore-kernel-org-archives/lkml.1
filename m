Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXDIUqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXDIUqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 16:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXDIUqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 16:46:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43615
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965013AbXDIUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 16:46:31 -0400
Date: Mon, 09 Apr 2007 13:46:31 -0700 (PDT)
Message-Id: <20070409.134631.71091422.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       cramerj@intel.com, auke-jan.h.kok@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH 2/2] NET: Multiqueue network device support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC329029E3EE5@orsmsx414.amr.corp.intel.com>
References: <20070409.133753.108740229.davem@davemloft.net>
	<D5C1322C3E673F459512FB59E0DDC329029E3EE5@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Mon, 9 Apr 2007 13:43:11 -0700

> True, but the assignment for "dev" above also casts this void * to
> struct net_device *:
> 
>         dev = (struct net_device *)
>                 (((long)p + NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
>         dev->padded = (char *)dev - (char *)p;
> 
> Shall I remove my cast?

I think so.  Casts tend to be red flags during patch review,
so don't add them when not necessary and let's remove the
unnecessary ones too.
