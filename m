Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYIUXwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYIUXwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 19:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYIUXwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 19:52:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45799
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752795AbYIUXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 19:52:11 -0400
Date: Sun, 21 Sep 2008 16:51:59 -0700 (PDT)
Message-Id: <20080921.165159.67476441.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, david.vrabel@csr.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
From: David Miller <davem@davemloft.net>
In-Reply-To: <7lIhZC4hCxE.A.yj.E2q1IB@albercik>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik>
	<7lIhZC4hCxE.A.yj.E2q1IB@albercik>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Sun, 21 Sep 2008 20:54:13 +0200 (CEST)

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11382
> Subject		: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
> Submitter	: David Vrabel <david.vrabel@csr.com>
> Date		: 2008-08-08 10:47 (45 days old)
> References	: http://marc.info/?l=linux-kernel&m=121819267211679&w=4
> Handled-By	: Christopher Li <chrisl@vmware.com>

Fixed by:

commit 78566fecbb12a7616ae9a88b2ffbc8062c4a89e3
Author: Christopher Li <chrisl@vmware.com>
Date:   Fri Sep 5 14:04:05 2008 -0700

    e1000: prevent corruption of EEPROM/NVM
    
    Andrey reports e1000 corruption, and that a patch in vmware's ESX fixed
    it.
    
    The EEPROM corruption is triggered by concurrent access of the EEPROM
    read/write. Putting a lock around it solve the problem.
    
    [akpm@linux-foundation.org: use DEFINE_SPINLOCK to avoid confusing lockdep]
    Signed-off-by: Christopher Li <chrisl@vmware.com>
    Reported-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Cc: Zach Amsden <zach@vmware.com>
    Cc: Pratap Subrahmanyam <pratap@vmware.com>
    Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Cc: Bruce Allan <bruce.w.allan@intel.com>
    Cc: PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>
    Cc: John Ronciak <john.ronciak@intel.com>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
