Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYCKWZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYCKWZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbYCKWZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:25:14 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:43297 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751474AbYCKWZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:25:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ClBVA38ujqVF+m6ZfpoiyfpazdOHGyzZdD0BunOt1Dk75WnbpFUKdOr7Sqny978Z8LSuOZ+Gw8Jq1RdPGNrY3wcyLdmbYXHDcFzz4j3maSZEjsAYNNECWVwmZdj159nSYIKgeEkU98JikcwcCExBxoyXQe/CtP93HAaoJlem9aQ=  ;
X-YMail-OSG: VEI35xoVM1mYQI3E85p6qzkwXk19KS1PCPxHN_2PAPdRgGeDbZaKutB9Md5.aEilhFZWjFacEQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Tue, 11 Mar 2008 14:25:10 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <1205230841.13653.204.camel@localhost.localdomain> <200803111436.29073.david-b@pacbell.net>
In-Reply-To: <200803111436.29073.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803111525.10717.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, David Brownell wrote:
> How would you see your notion of a "regulator" (client?)
> relating to a "power domain"?  My first thought is that
> there's a one-to-one correspondence but they may not be
> quite the same thing.  Example, one might want to ask the
> domain what devices it supports ... so that you could ask
> them all to power off.

Actually, it's clearly not one-to-one.  Counter-example:
a 3V3 regulator powering one of a SOC's I/O power domains,
which is managed by a digital switch.  That same regulator
can power several I/O devices too.  It may even feed a 1V8
regulator.

So the relationship is probably that regulators define a
domain ... but such domains can be subdivided.  There's
a tree; it's probably more shallow than the clock tree.

And enable/disable primitives probably map best to power
domains, not all of which are entire regulators.

- Dave
