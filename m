Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXEWPdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXEWPdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXEWPdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:33:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbXEWPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:33:09 -0400
Message-ID: <46545EA5.3020201@redhat.com>
Date: Wed, 23 May 2007 11:32:53 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: CONFIG_DEBUG_RODATA prevents kprobes from working on 2.6.22-rc2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes in the 2.6.22-rc2 kernel to the write protection of read only 
data enable by CONFIG_DEBUG_RODATA prevents kprobes from working. At least on 
the on i386 and x86_64 machine the mark_rodata_ro() function marks memory 
starting from _text as read only. Thus, when kprobes attempts to write a break 
point into a location in the kernel it faults.

There is a description of the problem at:

http://sources.redhat.com/bugzilla/show_bug.cgi?id=4531

Shouldn't mark_rodata_ro be less agressive when CONFIG_KPROBES is enabled? Or 
should kprobes temporarily change the page to be writeable, set the break point, 
and then return the page to read only?

-Will
