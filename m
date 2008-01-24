Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbYAXUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbYAXUq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759016AbYAXUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:39:54 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57695 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbYAXUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:39:53 -0500
Date: Thu, 24 Jan 2008 21:39:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
In-Reply-To: <20080124203335.082459062@polymtl.ca>
Message-ID: <Pine.LNX.4.64.0801242137020.12676@fbirervta.pbzchgretzou.qr>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 15:27, Mathieu Desnoyers wrote:
>such as:
>text_poke(addr, INIT_ARRAY(unsigned char, 0xf0, len), len);
 text_poke(addr, (unsigned char[]){[0 ... len-1] = val});

Well ugliness is debatable, but at least:

>+#define INIT_ARRAY(type, val, len) ((type [len]) { [0 ... (len)-1] = (val) })
  #define INIT_ARRAY(type, val, len) ((type[]){[0 ... (len)-1] = (val)})

You can use type[].
