Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZHRWKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZHRWKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZHRWKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:10:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:55790 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbZHRWKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:10:14 -0400
Message-Id: <DE9C9034-D2CE-4D21-93D9-A10FE2580920@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Linux-Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: spin_is_locked() broken for uniprocessor?
Date: Tue, 18 Aug 2009 17:09:56 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just want to validate that what I'm seeing (for UP, non-debug  
features):

spin_is_locked() is defined as:

include/linux/spinlock.h:#define spin_is_locked(lock)    
__raw_spin_is_locked(&(lock)->raw_lock)

for UP that should get us:

include/linux/spinlock_up.h:#define __raw_spin_is_locked(lock)  ((void) 
(lock), 0)

which implies to me that spin_is_locked() will always return false.   
Is this expected behavior.

- k
