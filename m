Return-Path: <linux-kernel-owner+w=401wt.eu-S1759101AbXKODIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101AbXKODIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 22:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXKODIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 22:08:42 -0500
Received: from ozlabs.org ([203.10.76.45]:57875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbXKODIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 22:08:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization
Date: Thu, 15 Nov 2007 14:08:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca>
In-Reply-To: <20071113190040.740103668@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711151408.46030.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 05:58:05 Mathieu Desnoyers wrote:
> x86 optimization of the immediate values which uses a movl with code
> patching to set/unset the value used to populate the register used as
> variable source.

For the record, I think the patching code gross overkill.

A stop_machine (or lightweight variant using IPI) would be sufficient and 
vastly simpler.  Trying to patch NMI handlers while they're running is 
already crazy.

I'd keep this version up your sleeve for they day when it's needed.

Rusty.
