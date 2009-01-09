Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbZAIV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbZAIV62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZAIV6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:58:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:41343 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755494AbZAIV6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:58:17 -0500
Date: Fri, 9 Jan 2009 22:58:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
cc: linux-kernel@vger.kernel.org
Subject: Does CONFIG_PARAVIRT imply usage of byte locks?
Message-ID: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

in [1] Linus states that CONFIG_PARAVIRT implies usage of inferior locks.

Looking at the code, I wonder whether are we in fact really using byte 
locks in CONFIG_PARAVIRT situation? Where are we actually setting 
pv_lock_ops.spin_lock pointer to point to __byte_spin_lock?

Such initialization seems to happen only in paravirt_use_bytelocks()
function, but my blind eyes prevent me from finding a callsite from which
this function would eventually get called.

It seems to me that paravirt_use_bytelocks() is a dead code that gets 
never called, and the same applies to the implementations of write locks. 
What did I miss?

[1] http://marc.info/?l=linux-kernel&m=123144211719754&w=2

Thanks,

-- 
Jiri Kosina
SUSE Labs
