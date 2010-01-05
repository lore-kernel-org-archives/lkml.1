Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240Ab0AERJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0AERJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223Ab0AERJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:09:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084Ab0AERJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:09:20 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1261541567.3508.73.camel@localhost.localdomain>
References: <1261541567.3508.73.camel@localhost.localdomain> <1261540762.3508.61.camel@localhost.localdomain> <1261540826.3508.62.camel@localhost.localdomain> <1261540902.3508.63.camel@localhost.localdomain> <1261540988.3508.64.camel@localhost.localdomain> <1261541054.3508.65.camel@localhost.localdomain> <1261541130.3508.66.camel@localhost.localdomain> <1261541188.3508.67.camel@localhost.localdomain> <1261541286.3508.69.camel@localhost.localdomain> <1261541342.3508.70.camel@localhost.localdomain> <1261541415.3508.71.camel@localhost.localdomain> <1261541491.3508.72.camel@localhost.localdomain> 
To: john stultz <johnstul@us.ibm.com>
Cc: dhowells@redhat.com, lkml <linux-kernel@vger.kernel.org>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com
Subject: Re: [RFC][PATCH 11/14] Convert mn10300 to read/update_persistent_clock
Date: Tue, 05 Jan 2010 17:08:56 +0000
Message-ID: <7145.1262711336@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> wrote:

> This patch converts the mn10300 architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
> 
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

arch/mn10300/kernel/rtc.c: In function `update_persistent_clock':
arch/mn10300/kernel/rtc.c:113: error: implicit declaration of function 'set_rtc_mms'
arch/mn10300/kernel/rtc.c: At top level:
arch/mn10300/kernel/rtc.c:24: warning: unused variable `last_rtc_update'
arch/mn10300/kernel/rtc.c:24: warning: 'last_rtc_update' defined but not used
arch/mn10300/kernel/rtc.c:51: warning: 'set_rtc_mmss' defined but not used

set_rtc_mms should be set_rtc_mmss in update_persistent_clock().  In fact,
set_rtc_mmss() should probably just be rolled into update_persistent_clock().

Furthermore, last_rtc_update and its comment should be deleted.

Apart from that, it seems to work.

David
