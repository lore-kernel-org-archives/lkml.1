Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0BCOtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:49:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572Ab0BCOtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:49:39 -0500
Message-ID: <4B698CEE.5020806@redhat.com>
Date: Wed, 03 Feb 2010 09:49:18 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Lubos Lunak <l.lunak@suse.cz>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Nick Piggin <npiggin@suse.de>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: Improving OOM killer
References: <201002012302.37380.l.lunak@suse.cz>
In-Reply-To: <201002012302.37380.l.lunak@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2010 05:02 PM, Lubos Lunak wrote:

>   In other words, use VmRSS for measuring memory usage instead of VmSize, and
> remove child accumulating.

I agree with removing the child accumulating code.  That code can
do a lot of harm with databases like postgresql, or cause the
system's main service (eg. httpd) to be killed when a broken cgi
script used up too much memory.

IIRC the child accumulating code was introduced to deal with
malicious code (fork bombs), but it makes things worse for the
(much more common) situation of a system without malicious
code simply running out of memory due to being very busy.

I have no strong opinion on using RSS vs VmSize.

-- 
All rights reversed.
