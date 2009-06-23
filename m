Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZFWMqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZFWMqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZFWMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:46:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:59505 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZFWMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YsaCmSdpHaLVAWuKj/GHfeQy5gV8sf0bNHlbs+LEJtrOpYGWVD1hgyI4LgfblMAGEv
         MgQgEro0RVud8H4+aum9brAsqinV0hD9jvnefqR4rOrumhwGG1IacFPOwn/kEJ09N8iK
         9cnMADvdw1j/S0zHZQhSC447ui8koUtxjLlEc=
Date: Tue, 23 Jun 2009 20:45:58 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: +
	printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
	.patch added to -mm tree
Message-ID: <20090623124558.GC12135@darkstar>
References: <200906230552.n5N5q3al012876@imap1.linux-foundation.org> <20090623071944.GB5747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623071944.GB5747@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 09:19:44AM +0200, Ingo Molnar wrote:
> 
> two minor comments:

Thanks for your comments and andrew's fixes.

> 
> > +++ a/kernel/printk.c
> > @@ -640,6 +640,19 @@ static int recursion_bug;
> >  static int new_text_line = 1;
> >  static char printk_buf[1024];
> >  
> > +int printk_delay_msec;
> 
> should be __read_mostly.
> 
> > +
> > +static inline void printk_delay(void)
> > +{
> > +	if (unlikely(printk_delay_msec)) {
> > +		int m = printk_delay_msec;
> > +		while (m--) {
> 
> newline needed after local variable.
> 
> 	Ingo
