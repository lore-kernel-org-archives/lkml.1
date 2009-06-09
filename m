Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZFIAuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZFIAuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZFIAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:50:12 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57751 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbZFIAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:50:11 -0400
Message-ID: <4A2DB1C6.6090209@linux.vnet.ibm.com>
Date: Mon, 08 Jun 2009 17:50:14 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: extensible perf_counter_attr
References: <1244481941.13761.9119.camel@twins> <4A2D6041.4050309@linux.vnet.ibm.com> <1244490680.6691.1.camel@laptop> <4A2D8011.9050502@linux.vnet.ibm.com> <1244496223.6691.2.camel@laptop> <4A2D82CE.9000206@linux.vnet.ibm.com> <20090608215002.GB22049@elte.hu>
In-Reply-To: <20090608215002.GB22049@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> 
>> Peter Zijlstra wrote:
>>> On Mon, 2009-06-08 at 14:18 -0700, Corey Ashford wrote:
>>>> pca.ext_attrs = &feature.head; /* secretly know that there's data 
>>>> that lies past the attr struct header */
>>> Right, except its not so very secret since we have the type field
>>> telling us.
>> I see.  Thanks for the explanation.  Looks like a good plan to me!
> 
> i think we'd have a much simpler implementation by changing 
> __reserved_1 to attr_size. When the kernel adds new attributes, the 
> size will increase - old user-space will use the old size which the 
> kernel detects and adopts to (by zeroing out that attribute space).
> 
> That way we'll always have a nice flat attributes structure, with no 
> quirky chaining that has field-dependent data types ...
> 
> 	Ingo

If I understand you correctly, you would simply make perf_counter_attr larger 
every time you want to add a new attribute.  Users using the new attributes 
would call sys_perf_counter_open with a larger attr_size value.

What about arch-dependent attributes?  Would you want to place them all in the 
perf_counter_attr struct?  I suppose this could be done by #include'ing an 
arch-specific .h file.

- Corey

