Return-Path: <linux-kernel-owner+w=401wt.eu-S1761279AbYARPWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbYARPWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:22:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757021AbYARPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:21:59 -0500
Received: from mx.dave-tech.it ([88.37.112.223]:50820 "EHLO mx.dave-tech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYARPV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:21:58 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 10:21:57 EST
Message-ID: <4790C282.1060904@dave-tech.it>
Date: Fri, 18 Jan 2008 16:15:14 +0100
From: llandre <r&d2@dave-tech.it>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.22.6 hangs in synchronize_rcu
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm porting kernel 2.6.22.6 on custom embedded system (ARM1136).
During network subsystem initialization, kernel hangs in function 
synchronize_rcu invoked by synchronize_net. In particular
wait_for_completion(&rcu.completion);
never returns and wakeme_after_rcu is never hit.
Anybody can give me any advice about how to investigate this issue?

void synchronize_rcu(void)
{
     struct rcu_synchronize rcu;

     init_completion(&rcu.completion);
     /* Will wake me after RCU finished */
     call_rcu(&rcu.head, wakeme_after_rcu);

     /* Wait for it */
     wait_for_completion(&rcu.completion);
}


Thanks in advance,
llandre

DAVE Electronics System House - R&D Department
web:   http://www.dave-tech.it
email: r&d2@dave-tech.it
