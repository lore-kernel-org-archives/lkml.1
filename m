Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab0BCLLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 06:11:11 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:33390 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab0BCLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 06:11:08 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o13B6veR012319
Subject: Re: [PATCH] drivers/acpi/ec.c fix a small memory leak
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4B684650.9070807@suse.de>
References: <1265112730.4804.8.camel@ICE-BOX>  <4B684650.9070807@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 12:06:57 +0100
Message-ID: <1265195217.2755.55.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-CTc-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2010-02-02 at 18:35 +0300, Alexey Starikovskiy wrote:
> NAK
> 
> saved_ec is allocated if flag EC_FLAGS_VALIDATE_ECDT is true.
> EC_FLAGS_SKIP_DSDT_SCAN have no sense in such case, thus this new code path
> is never executed.
> On the other hand, unconditionally freeing pointer, which is might be NULL, is not
> right either.
Why that?
"kfree(NULL);" works (and in the user-space "free(NULL)" too FWIW).

> So, this patch introduced more problems as it tries to solve...

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

