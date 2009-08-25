Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbZHYWPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbZHYWPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZHYWPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:15:00 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:50643 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZHYWO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:14:59 -0400
Date: Wed, 26 Aug 2009 00:19:03 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Dillow <dave@thedillows.org>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Message-ID: <20090825221903.GA13630@electric-eye.fr.zoreil.com>
References: <1250895567.23419.1.camel@obelisk.thedillows.org> <1250897657.23419.5.camel@obelisk.thedillows.org> <m1iqggf4rf.fsf@fess.ebiederm.org> <m18whcf3w2.fsf@fess.ebiederm.org> <1250973787.3582.14.camel@obelisk.thedillows.org> <m1r5v0ogvw.fsf@fess.ebiederm.org> <1251169150.4023.11.camel@obelisk.thedillows.org> <m1prajabk8.fsf@fess.ebiederm.org> <1251232848.9607.15.camel@lap75545.ornl.gov> <m1k50r8u4p.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k50r8u4p.fsf@fess.ebiederm.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> :
[...]
> I am a bit curious about TxDescUnavail.  Perhaps we had a temporary
> memory shortage and that is what was screaming?  I don't think we do
> anything at all with that state.

You are not alone, the driver completely ignores this bit.

As far as I remember, the TxDescUnavail event mostly pops up when the
driver makes an excessive use of TxPoll requests.

> Perhaps the flaw here is simply not masking TxDescUnavail while we are
> in NAPI mode ?

Yes, it is worth trying.

-- 
Ueimor
