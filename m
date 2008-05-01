Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYEAUp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYEAUp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759005AbYEAUps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:45:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:33194 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbYEAUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:45:47 -0400
Message-ID: <481A2BF6.2070406@austin.ibm.com>
Date: Thu, 01 May 2008 15:45:42 -0500
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: questions on calc_delta_mine() in sched.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I have a few questions regarding  this code in kernel/sched.c

static unsigned long
calc_delta_mine(unsigned long delta_exec, unsigned long weight,
         struct load_weight *lw)
{
     u64 tmp;

     if (unlikely(!lw->inv_weight))
         lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);


Q1) This code is hit often in scenarios I run, is this really unlikely for 
others?
Q2) The rest of the code in sched.c seems to make inv_weight == 
WMULT_CONST/weight and I was wondering if you could explain why this 
instance is different.
Q3) That division is pretty expensive, could we sacrifice some accuracy and 
do a precompute table?  Do you have another idea how we could get rid of 
the divide?

-Joel Schopp

