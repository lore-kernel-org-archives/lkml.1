Return-Path: <linux-kernel-owner+w=401wt.eu-S935743AbXJSRY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935743AbXJSRY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934180AbXJSRUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:20:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50102 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763399AbXJSRTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:19:49 -0400
Subject: Re: [kvm-devel] Use virtual cpu accounting if available for guest
	times.
From: Hollis Blanchard <hollisb@us.ibm.com>
Reply-To: Hollis Blanchard <hollisb@us.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1192813056.10451.6.camel@basalt>
References: <47135D1B.1060004@bull.net>
	 <11926264852739-git-send-email-Laurent.Vivier@bull.net>
	 <200710181439.10390.borntraeger@de.ibm.com>
	 <1192813056.10451.6.camel@basalt>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 19 Oct 2007 12:18:56 -0500
Message-Id: <1192814336.10451.20.camel@basalt>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-19 at 11:57 -0500, Hollis Blanchard wrote:
> > @@ -669,11 +670,13 @@ __init void kvm_arch_init(void);
> > 
> >  static inline void kvm_guest_enter(void)
> >  {
> > +	account_system_vtime(current);
> >  	current->flags |= PF_VCPU;
> >  }
> > 
> >  static inline void kvm_guest_exit(void)
> >  {
> > +	account_system_vtime(current);
> >  	current->flags &= ~PF_VCPU;
> >  }
> 
> I don't understand. Should kvm_guest_exit() be calling
> account_user_vtime() (instead of account_system_vtime())?

Never mind; the tree I was looking at didn't have the
account_guest_time() stuff in account_system_time().

-- 
Hollis Blanchard
IBM Linux Technology Center

