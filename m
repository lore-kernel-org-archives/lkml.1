Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbXFLMGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbXFLMGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXFLMGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:06:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55914 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbXFLMGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:06:30 -0400
Subject: Re: splice: move balance_dirty_pages_ratelimited() outside of 
	splice actor
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070612113101.GZ18832@kernel.dk>
References: <200706112159.l5BLxF5x004043@hera.kernel.org>
	 <20070611163433.dbc541ec.akpm@linux-foundation.org>
	 <20070612063510.GO18832@kernel.dk> <20070612112059.GY18832@kernel.dk>
	 <20070612113101.GZ18832@kernel.dk>
Content-Type: text/plain
Date: Tue, 12 Jun 2007 14:06:23 +0200
Message-Id: <1181649983.7348.309.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 13:31 +0200, Jens Axboe wrote:

> Would you prefer this change, then? I'd prefer keeping the current code,
> unless it's absolutely critical that we call
> balance_dirty_pages_ratelimited() for each and every page instead of eg
> every 16 pages here.

For that we should call:
  balance_dirty_pages_ratelimited_nr(mapping, nr);

Which is ok, for small nr.


