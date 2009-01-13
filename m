Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZAMJqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZAMJqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZAMJqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:46:39 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39673 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZAMJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:46:38 -0500
In-Reply-To: <20090113091703.566663ce@lxorguk.ukuu.org.uk>
Subject: Re: ALLANC: Proposal to add progress records to process accounting
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Lotus Notes Release 7.0 August 18, 2005
Message-ID: <OF2335529A.66035AF5-ONC825753D.00347776-C825753D.0035AF28@au1.ibm.com>
From: Allan Chandler <allachan@au1.ibm.com>
Date: Tue, 13 Jan 2009 18:49:25 +0900
X-MIMETrack: Serialize by Router on d23ml003/23/M/IBM(Release 7.0.2FP3HF80 | July 14, 2008) at
 13/01/2009 20:49:26
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you planning to update the log based upon wall time or cpu used ?

I planned on using the exact same algorithm as is used currently. I believe
the current->signal->pacct structure holds system and user CPU time which
is copied into the log ac_stime and ac_utime entries respectively in
kernel/acct.c/do_acct_proces() thus:
      ac.ac_utime =
encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_utime)));
      ac.ac_stime =
encode_comp_t(jiffies_to_AHZ(cputime_to_jiffies(pacct->ac_stime)));

The log ac_etime is elapsed time (which is what I assume you mean by wall
time) and is calculated as current_uptime - process_start_time
(paraphrased) in the same function.

Cheers,
Pax.
==========
Two strings walk into a bar. The first one says: "Hello, I'd like some
Vodka please.ytewsr@)W$(#*$&!^Y@)^&30@#!".
"You'll have to excuse my friend," the second one says, "he's not
null-terminated".
==========
Allan Chandler (Pax), Senior IT Specialist, Australia Development
Laboratory (ADL), Perth, IBM Corporation
Internet: allachan@au1.ibm.com, Phone: +61 8 926 13019, Fax: +61 8 921
89201
Location code MP25, 77 St George's Terrace (Allendale Square), Level 25,
Perth WA 6000
_______________________________________________



                                                                           
             Alan Cox                                                      
             <alan@lxorguk.uku                                             
             u.org.uk>                                                  To 
             Sent by:                  Allan Chandler/Australia/IBM@IBMAU  
             linux-kernel-owne                                          cc 
             r@vger.kernel.org         linux-kernel@vger.kernel.org        
                                                                   Subject 
                                       Re: ALLANC: Proposal to add         
             13/01/2009 06:17          progress records to process         
             PM                        accounting                          
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           




> will be written for any process that hasn't written a record in a while
> (for our purposes, 24 hours is fine but it may be better to make this
> configurable).

Agreed and this sounds sensible.

> too much overhead to the context switch (that's putting it mildly).  I
> assume this would be somewhere in kernel/sched.c/context_switch() or
> kernel/sched.c/prepare_task_switch() although I haven't yet looked in
great
> detail.

Are you planning to update the log based upon wall time or cpu used ?

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


