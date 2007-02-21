Return-Path: <linux-kernel-owner+w=401wt.eu-S1422717AbXBURVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717AbXBURVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422719AbXBURVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:21:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422717AbXBURVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:21:22 -0500
Message-ID: <45DC7F6D.3020200@redhat.com>
Date: Wed, 21 Feb 2007 12:20:45 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 03/18] Dont leak NT bit into next task
References: <20070221014413.282048309@mini.kroah.org> <20070221014953.GD3684@kroah.com> <erh57g$oeb$1@sea.gmane.org>
In-Reply-To: <erh57g$oeb$1@sea.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta wrote:
> On Wednesday 21 February 2007 02:49, Greg KH wrote:
> 
>>  /* frame pointer must be last for get_wchan */
>> -#define SAVE_CONTEXT    "pushq %%rbp ; movq %%rsi,%%rbp\n\t"
>> -#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp\n\t"
>> +#define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
>> +#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
> 
> No idea if this is a problem or not, but you forgot a \n after popf.
> 

It's that way in 2.6.21-rc1.
