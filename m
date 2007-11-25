Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbXKYX3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbXKYX3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 18:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757214AbXKYX3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 18:29:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33367 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXKYX3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 18:29:17 -0500
Date: Sun, 25 Nov 2007 15:27:45 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125152745.6d23f435@laptopd505.fenrus.org>
In-Reply-To: <20071125165654.GE21947@stusta.de>
References: <20071125161801.GB21947@stusta.de>
	<20071125162105.GA6658@kernel.dk>
	<20071125163153.GD21947@stusta.de>
	<20071125164532.GB6658@kernel.dk>
	<20071125165654.GE21947@stusta.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007 17:56:54 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> Is there any technical reason why we need 4 different schedulers at
> all?
> 

there is at least one technical reason to need more than one: certain
types of storage (both big EMC boxes as well as solid state disks)
don't behave like disks and have no seek penalty; any cpu time spent on
avoiding seeks is wasted on those, so for these devices one really
wants to use a different IO scheduler, one which is much lighter weight
