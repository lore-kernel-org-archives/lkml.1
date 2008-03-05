Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbYCENzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbYCENzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYCENyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:54:12 -0500
Received: from smtp2f.orange.fr ([80.12.242.151]:64867 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbYCENyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:54:09 -0500
X-ME-UUID: 20080305130906964.EB68C70000B6@mwinf2f28.orange.fr
Message-ID: <47CE9B70.6090707@cosmosbay.com>
Date: Wed, 05 Mar 2008 14:09:04 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] is CONFIG_DEBUG_STACK_USAGE supported on STACK_GROWSUP arches
  ?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle

I was wondering how following code could work on PARISC :

kernel/sched.c

#ifdef CONFIG_DEBUG_STACK_USAGE
        {
                unsigned long *n = end_of_stack(p);
                while (!*n)
                        n++;
                free = (unsigned long)n - (unsigned long)end_of_stack(p);
        }
#endif


I am trying to define a bytes_free_in_stack() function, and was about to 
code something like :

/*
 * Only called in process context
 */
static inline unsigned long bytes_free_in_stack()
{
#ifdef CONFIG_STACK_GROWSUP
   unsigned long free = (unsigned long)end_of_stack(current) - (unsigned 
long)&free;
#else
   unsigned long free = (unsigned long)&free - (unsigned 
long)end_of_stack(current);
#endif
  return free;
}

but I realize it wont work on PARISC (and more generally on 
STACK_GROWSUP arches)

Thank you
Eric



