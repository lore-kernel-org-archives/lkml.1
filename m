Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZJVNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZJVNoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZJVNoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 09:44:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:33531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbZJVNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 09:44:36 -0400
Date: Thu, 22 Oct 2009 06:45:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Leonidas ." <leonidas137@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Can current macro be accessed from interrupt context?
Message-ID: <20091022064538.25837421@infradead.org>
In-Reply-To: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 04:10:49 -0700
"Leonidas ." <leonidas137@gmail.com> wrote:

> Hello,
> 
> Going through UTLK, it says that current macro makes sense only in
> case of process context,
> in case of interrupt context it is invalid.
> 
> But current would still be pointing to interrupted process right? The
> pointer would still be valid?
> Can I safely assume that whether or not interrupt handlers are
> executing on separate stacks or
> interrupted threads stack, current macro can be accessed from
> interrupt context?

not for interrupt threads, and that's where things are moving to.

for interrupt stacks you ought to be fine (current is just a pointer on
the stack, and last I looked we copied that pointer for each interrupt
to the irq stack)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
