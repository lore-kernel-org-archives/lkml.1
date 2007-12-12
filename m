Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbXLLFfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbXLLFfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXLLFfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:35:25 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2984 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXLLFfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:35:24 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Theodore Tso" <tytso@mit.edu>, "Matt Mackall" <mpm@selenic.com>,
       "Marc Haber" <mh+linux-kernel@zugschlus.de>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Adrian Bunk" <bunk@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Why does reading from /dev/urandom deplete entropy so much?
Date: Tue, 11 Dec 2007 21:34:37 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEHOIMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <475EE920.7000108@cfl.rr.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 11 Dec 2007 21:35:38 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 11 Dec 2007 21:35:39 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Phillip Susi wrote:

> What good does using multiple levels of RNG do?  Why seed one RNG from
> another?  Wouldn't it be better to have just one RNG that everybody
> uses?  Doesn't the act of reading from the RNG add entropy to it, since
> no one reader has any idea how often and at what times other readers are
> stirring the pool?

No, unfortunately. The problem is that while in most typical cases may be
true, the estimate of how much entropy we have has to be based on the
assumption that everything we've done up to that point has been carefully
orchestrated by the mortal enemy of whatever is currently asking us for
entropy.

While I don't have any easy solutions with obvious irrefutable technical
brilliance or that will make everyone happy, I do think that one of the
problems is that neither /dev/random nor /dev/urandom are guaranteed to
provide what most people want. In the most common use case, you want
crypographically-strong randomness even under the assumption that all
previous activity is orchestrated by the enemy. Unfortunately, /dev/urandom
will happily give you randomness worse than this while /dev/random will
block even when you have it.

DS


