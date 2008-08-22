Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYHVOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYHVOuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbYHVOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:49:58 -0400
Received: from s200bog14.obsmtp.com ([207.126.150.128]:38808 "EHLO
	s200bog14.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYHVOt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:49:57 -0400
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
From: Pawel MOLL <pawel.moll@st.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@st.com>
In-Reply-To: <1219313656.31630.89.camel@bri1004.bri.st.com>
References: <1219313656.31630.89.camel@bri1004.bri.st.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 22 Aug 2008 15:49:44 +0100
Message-Id: <1219416584.31630.639.camel@bri1004.bri.st.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

Apparently I have swapped To: and Cc: field in the original mail,
apologies.

> This patch clarifies a usage of irq_chip->startup() callback:
> 
> 1. The "if (startup) startup(); else enabled();" code in setup_irq()
>    is unnecessary, as startup() falls back to enabled() via
>    default callbacks, set by irq_chip_set_defaults().
> 
> 2. When using set_irq_chained_handler() the startup() was never called,
>    which is not good at all... Fixed. And again - when startup() is not
>    defined the call will fall back to enable() than to unmask() via
>    default callbacks.

Any comment on the patch?

Best regards

Paweł

