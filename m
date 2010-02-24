Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab0BXWF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:05:59 -0500
Received: from mail-ew0-f212.google.com ([209.85.219.212]:42312 "EHLO
	mail-ew0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab0BXWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ixjPItuAbuuun5vLOo5hZlWpvfNcQD4Ht/1ciFHVp2ZNF8p0oHpllGcavSKa/Ocrst
         OEnzjcugQPICSOtZAeEqgQjO7kWMJabs9o0eI5V83Scr/OlYPUqAZZQ4bQBtNnf2tpmX
         koXKmy3FGSad8Pmz/Fx0JWZzutZlRUGuFBM24=
Message-ID: <4B85A49E.6000803@gmail.com>
Date: Wed, 24 Feb 2010 23:13:50 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "lkml" <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Is kernel optimized with dead store removal?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to http://cwe.mitre.org/data/slices/2000.html#14 due to optimization
A call to memset() can be removed as a dead store when the buffer is not used
after its value is overwritten. Does this optimization also occur during
compilation of the Linux kernel? Then I think I may have found some
vulnerabilities. One is sha1_update() where memset(temp, 0, sizeof(temp)); may
be removed.

Roel
