Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXDOAri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXDOAri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 20:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXDOAri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 20:47:38 -0400
Received: from mx27.mail.ru ([194.67.23.64]:15407 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXDOArh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 20:47:37 -0400
Date: Sun, 15 Apr 2007 04:43:54 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Shem Multinymous <multinymous@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070415004354.GA23559@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070413134939.GA20618@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070413134939.GA20618@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 05:49:39PM +0400, Anton Vorontsov wrote:
> I'll convert mXh to uXh a bit later, if there will no further objections
> against uXh. Also I'd like to hear if there any objections on
> mA/mV -> uA/uV conversion. I think we'd better keep all units at the
> same order/precision.

Okay, would it make sense to use "long" instead of "int" after "milli" to
"micro" conversion? On 32 bit machines int gives +-2147483648 limit. So
2147 volts/amperes/...

Though 2147 amperes is unrealistic for batteries, but if used in
calculations it could be dangerous.

For example:
di->life_sec = -((di->accum_current_uAh - di->empty_uAh) *
                 3600) / di->current_uA;

It can be also solved (and I voting for it) by typecasting to long
in the driver itself.

Would it also make sense to use int64_t instead of long? And how should
it passed to printk in portable way? I guess printk (vsprintf) does not
support PRIx notation as defined in /usr/include/inttypes.h ?

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
