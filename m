Return-Path: <linux-kernel-owner+w=401wt.eu-S1760682AbZFPSFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682AbZFPSFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760273AbZFPSFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:05:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37281 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759550AbZFPSFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:05:08 -0400
Message-ID: <4A37DEE7.1000208@redhat.com>
Date: Tue, 16 Jun 2009 21:05:27 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, nickpiggin@yahoo.com.au
Subject: running get_user_pages() from kernel thread
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

ksm is running from its kernel thread context get_user_pages(), but look 
like it isnt safe to do get_user_pages() from kernel thread:
get_user_pages may lead into do_swap_page() that may lead into calling 
grab_swap_token()

Now grab_swap_token() will do:
current_interval = global_faults - current->mm->... (here is the bug... 
(kernel thread doesnt have mm strcture)

So the question is: is this thing is by desgin? (that kernel thread cant 
call get_user_pages???), should i use something like switch_mm()??

Thanks.


