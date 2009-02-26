Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbZBZXPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbZBZXPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 18:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbZBZXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 18:15:38 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:1669 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758639AbZBZXPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 18:15:37 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Thu, 26 Feb 2009 18:15:10 -0500
Message-Id: <20090226230338.M86894@bobcopeland.com>
In-Reply-To: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
X-Mailer: OpenWebMail 2.53 
X-OriginatingIP: 149.101.1.121 (bob)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 23:44:31 +0100, Jiri Slaby wrote
> Make sure we print out a warning when the index is out of bounds,
> i.e. even on hw_rix == AR5K_MAX_RATES.
> 
> Also change to WARN and print text with the reported hw_rix.

ACK.

Speaking of, I think there's another potential oob array access at:

if (rxs.rate_idx >= 0 && rs.rs_rate == 
    sc->curband->bitrates[rxs.rate_idx].hw_value_short)
        rxs.flag |= RX_FLAG_SHORTPRE;

because sc->rate_idx is u8 instead of s8.

-- 
Bob Copeland %% www.bobcopeland.com


