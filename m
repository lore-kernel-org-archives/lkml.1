Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZDQVwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZDQVwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZDQVwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:52:04 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2086 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZDQVwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:52:03 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 17:52:03 EDT
Date: Fri, 17 Apr 2009 23:42:12 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: have non-spinning mutexes on s390 by default
Message-ID: <20090417214212.GG10554@vanheusden.com>
References: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409174758.74abec87@osiris.boeblingen.de.ibm.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Apr 18 21:15:00 CEST 2009
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The adaptive spinning mutexes will not always do what one would expect on
> virtualized architectures like s390. Especially the cpu_relax() loop in
> mutex_spin_on_owner might hurt if the mutex holding cpu has been scheduled
> away by the hypervisor.
> We would end up in a cpu_relax() loop when there is no chance that the
> state of the mutex changes until the target cpu has been scheduled again by
> the hypervisor.
> For that reason we should change the default behaviour to no-spin on s390.

Hmmm. Wouldn't this be a change that applies to ibm system p as wel?
E.g. with linux in an lpar.


Folkert van Heusden

-- 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
