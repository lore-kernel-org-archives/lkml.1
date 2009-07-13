Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZGMUSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZGMUSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZGMUSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:18:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:10977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071AbZGMUSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:18:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,392,1243839600"; 
   d="scan'208";a="707440730"
Subject: Re: iwl: potential deadlock?
From: reinette chatre <reinette.chatre@intel.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5B8C60.9000600@gmail.com>
References: <4A5B8C60.9000600@gmail.com>
Content-Type: text/plain
Date: Mon, 13 Jul 2009 13:18:40 -0700
Message-Id: <1247516320.17896.1640.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 2009-07-13 at 12:34 -0700, Jiri Slaby wrote:
> Hi,
> 
> we found a potential deadlock in iwl code by our tool.

What tool is this?

> 
> Can this happen:

I don't think so ...

> iwl_update_tkip_key()
> -> spin_lock_irqsave(&priv->sta_lock)
> -> iwl_send_add_sta()

iwl_send_add_sta() is called here with flags = CMD_ASYNC

In iwl_send_add_sta() we have:
	if (ret || (flags & CMD_ASYNC))
		return ret;

>    -> iwl_sta_ucode_activate()

... so this is not run in this case.

>       -> spin_lock_irqsave(&priv->sta_lock)

Reinette

