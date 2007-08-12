Return-Path: <linux-kernel-owner+w=401wt.eu-S936620AbXHLSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936620AbXHLSax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932409AbXHLSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:30:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56666 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763162AbXHLSao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:30:44 -0400
Subject: Re: [patch 0/8] Immediate Values
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070812150702.769065566@polymtl.ca>
References: <20070812150702.769065566@polymtl.ca>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 12 Aug 2007 11:27:23 -0700
Message-Id: <1186943243.2854.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-08-12 at 11:07 -0400, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Here is the latest version of immediate values. It applies on 2.6.23-rc2-mm2 in
> this order:


I have a concern; you seem to be patching potentially "live" code....

there are basically two options
1) you run the risk of triple faulting (patching an instruction while
some other core/cpu may be decoding it may cause a triple fault)
2) you do an IPI to all other cpus and prevent them from executing any
code except a small loop during the patching... this is expensive.

To be honest, neither sound very attractive to me ;(


