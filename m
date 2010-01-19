Return-Path: <linux-kernel-owner+w=401wt.eu-S1751640Ab0ASOcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab0ASOcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574Ab0ASOcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0ASOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:32:10 -0500
Date: Tue, 19 Jan 2010 16:29:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100119142902.GA28465@redhat.com>
References: <cover.1263402727.git.mst@redhat.com> <20100113171230.GB19798@redhat.com> <4B55B2B8.5090105@siemens.com> <20100119134827.GA28191@redhat.com> <4B55BBB6.2020901@siemens.com> <20100119140425.GA28410@redhat.com> <4B55C05D.9000509@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B55C05D.9000509@siemens.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:23:25PM +0100, Jan Kiszka wrote:
> Michael S. Tsirkin wrote:
> >>>> I just wonder how broad
> >>>> the impact of a broken or non-existent eventfd subsystem for kvm-kmod
> >>>> is. Any thoughts welcome.
> >>> How do you handle kernels that don't export eventfd_ctx_fileget?
> >> Now that you mention it: not yet properly. So far we pass the file
> >> struct as pseudo eventfd_ctx around on < 2.6.31. But now that I peek
> >> into the struct in kvm_eventfd_ctx_remove_wait_queue, this should should
> >> crash. Guess I need to look up that module the same way as I acquire
> >> __wake_up_locked[_key].
> > 
> > This won't work that well: eventfd in upstream
> > sends us POLLHUP so we can close the structure,
> > in old kernels it doesn't so kernel will crash
> > when we try to reference the structure later.
> > 
> 
> OK, so any host kernel < 2.6.31 will never work for us. Mmh, then I
> could only close the gap 2.6.31..2.6.33. vhost will show up in 33...
> Will that version already be worth any eventfd wrapping?
> 
> Jan

I asked Avi to send a patch upstream into 2.6.32.X fixing spurious
interrupts there. 2.6.31-stable is closed unfortunately, so we won't be
able to support it.  Disable eventfd there?

> -- 
> Siemens AG, Corporate Technology, CT T DE IT 1
> Corporate Competence Center Embedded Linux
