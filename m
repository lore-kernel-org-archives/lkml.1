Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZIQSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZIQSLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZIQSLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:11:31 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:59445 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZIQSLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:11:31 -0400
Date: Thu, 17 Sep 2009 19:11:33 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: rt2x00dev.c:405: error: =?utf-8?Q?too_?=
	=?utf-8?Q?few_arguments_to_function_=E2=80=98rt2x00crypto=5Frx=5Finsert?=
	=?utf-8?B?X2l24oCZ?=
Message-ID: <20090917181133.GA5797@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
References: <20090917154138.GA31844@sucs.org> <20090917172358.GC2577@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090917172358.GC2577@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:23:59PM -0400, John W. Linville wrote:
> On Thu, Sep 17, 2009 at 04:41:39PM +0100, Andrew Price wrote:
> > Hi Ivo,
> > 
> > Apologies if this has already been reported. Building today's mainline
> > kernel (ab86e5) I'm seeing this error:
> > 
> > drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_rxdone’:
> > drivers/net/wireless/rt2x00/rt2x00dev.c:405: warning: passing argument 3 of ‘rt2x00crypto_rx_insert_iv’ makes integer from pointer without a cast
> > drivers/net/wireless/rt2x00/rt2x00dev.c:405: error: too few arguments to function ‘rt2x00crypto_rx_insert_iv’
> 
> Strange...I don't see this warning.  Are you sure you have a clean checkout?

I double-checked:

- git status returned no changes
- git clean -fqdx
- ccache -C
- Retried the build

and still got the same error. Is this something to do with the second
definition of rt2x00crypto_rx_insert_iv still having an l2pad parameter...

This (untested) patch fixes the build for me:

--

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 5462cb5..567f029 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -380,7 +380,7 @@ static inline void rt2x00crypto_tx_insert_iv(struct sk_buff *skb,
 {
 }
 
-static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, bool l2pad,
+static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 					     unsigned int header_length,
 					     struct rxdone_entry_desc *rxdesc)
 {
