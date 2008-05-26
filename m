Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYEZJHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYEZJHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYEZJHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:07:09 -0400
Received: from ns.firmix.at ([62.141.48.66]:3894 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbYEZJHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:07:08 -0400
Subject: Re: question about splice performance
From: Bernd Petrovitsch <bernd@firmix.at>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
In-Reply-To: <38b2ab8a0805260157k14d9a64dkeef48d230b978cf4@mail.gmail.com>
References: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
	 <4839D05C.4040309@garzik.org>
	 <38b2ab8a0805260157k14d9a64dkeef48d230b978cf4@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 26 May 2008 11:06:41 +0200
Message-Id: <1211792801.2052.14.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.338 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.338 required=5
X-Spam-Score: -2.338 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2008-05-26 at 10:57 +0200, Francis Moreau wrote:
> On Sun, May 25, 2008 at 10:47 PM, Jeff Garzik <jeff@garzik.org> wrote:
> >
> > If you drop caches you are not measuring splice speed.
> >
> > Use ramfs for your tests (guarantees data is in cache) instead.
> 
> So it seems that the gain when using splice to copy a file into another file
> is very limited. Maybe that's the reason why cp is still using read/write...

To point it out one more time: If you copy from one file on a physical
harddisk (or more or less similar hardware) to another (with cold
caches), the bottleneck is most probably the harddisk.

splice() simply reduces the amount of copied data in the RAM - and that
is practically irrelevant if you read and write to and from harddisks.

So if you want to measure the savings of using splice() (instad of
read()/write(), etc.): Copy to and from RAM disks (and thus rule out the
slow hardware).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


