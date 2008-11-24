Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYKXJ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYKXJ5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYKXJ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:57:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:55239 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751924AbYKXJ5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:57:30 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/yr109Uu3y5/3dGdW6Ha6gzRi+Wn7J7tnJGKtlQL
	vJ7wGDShZN644T
Date: Mon, 24 Nov 2008 10:57:33 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: leds/leds-pca955x.c: small and, probably, hatmless race window
Message-ID: <Pine.LNX.4.64.0811241053190.4148@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

leds/leds-pca955x.c does on two occasions:

	kfree(pca955x);
	i2c_set_clientdata(client, NULL);

which means, between these two calls dev->driver_data points to a freed 
location. One of these two occasions is in probe on the error path, 
another in release, thus, both are, probably, harmless, still would be 
better to fix?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
