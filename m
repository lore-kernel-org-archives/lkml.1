Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbZBLT6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbZBLT6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZBLT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:58:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:33173 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZBLT6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:58:01 -0500
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: wli@movementarian.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu>
	<20090212001223.GA5757@movementarian.org>
	<alpine.DEB.2.00.0902121006440.18739@blackhole.kfki.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 12 Feb 2009 11:58:04 -0800
In-Reply-To: <alpine.DEB.2.00.0902121006440.18739@blackhole.kfki.hu> (Jozsef Kadlecsik's message of "Thu\, 12 Feb 2009 10\:11\:43 +0100 \(CET\)")
Message-ID: <m1wsbvctrn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kadlec@blackhole.kfki.hu, rusty@rustcorp.com.au, netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, wli@movementarian.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> writes:

> On Wed, 11 Feb 2009, wli@movementarian.org wrote:
>
>> On Wed, Feb 11, 2009 at 11:19:20AM +0100, Jozsef Kadlecsik wrote:
>> >  /* The golden ration: an arbitrary value */
>> > -#define JHASH_GOLDEN_RATIO	0x9e3779b9
>> > +#define JHASH_GOLDEN_RATIO	0xdeadbeef
>> 

0xdeadbeef is a really bad choice of an arbitrary value.  It is
already used in multiple places.  Only a few of which are currently
listed in linux/poison.h and if I happened to see that number in a
debug trace having to sort through all of the possible sources looks
like a major pain.

I don't really care what we call it but somehow 0xdeadbeef strikes me
as wrong and something that will make debugging harder.

Eric
