Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934585Ab0BYX6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:58:10 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42217 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934566Ab0BYX6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:58:07 -0500
X-Sasl-enc: D0/vT5yd3yZScqiwPp1XOVlNrjZaf+FyFVJkhjDOZAcN 1267142284
Date: Thu, 25 Feb 2010 20:58:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Roel Kluin <roel.kluin@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: Is kernel optimized with dead store removal?
Message-ID: <20100225235801.GE5218@khazad-dum.debian.net>
References: <4B85A49E.6000803@gmail.com>
 <19334.22971.970220.245930@pilspetsen.it.uu.se>
 <4B8693B9.3060102@gmail.com>
 <19334.40943.479593.304961@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19334.40943.479593.304961@pilspetsen.it.uu.se>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Mikael Pettersson wrote:
>  > In the sha1_update() case I don't know whether the stack is recycled and
>  > leaked - it may be dependent on the calling function, but isn't it
>  > vulnerable?
> 
> It's only vulnerable if the data leaks to a less trusted domain.

If it is anything you wanted to protect badly enough that you already have
code to clobber it later, this *is* a security bug.

Not only you remove one layer of security, you also widen a lot the window
of opportunity to, e.g., http://en.wikipedia.org/wiki/Cold_boot_attack

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
