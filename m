Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbYBNVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbYBNVCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYBNVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:02:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53378 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbYBNVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:02:03 -0500
Date: Thu, 14 Feb 2008 13:00:03 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: pageexec@freemail.hu, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214130003.4d40d938@laptopd505.fenrus.org>
In-Reply-To: <20080214202535.GA25316@elte.hu>
References: <20080214190050.GA32258@elte.hu>
	<47B4AAB8.106.FEA5232@pageexec.freemail.hu>
	<20080214202535.GA25316@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 21:25:35 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * pageexec@freemail.hu <pageexec@freemail.hu> wrote:
> 
> > really, the best defense is to reduce the useful lifetime of any 
> > leaked canary, and you can't get better than syscall granularity 
> > without disproportional effort and impact elsewhere (and i'm sure
> > some would find even this disproportional ;).
> 
> hm, i think per syscall canaries are really expensive.


it's not that bad. Assuming you use a PNR that you re-seed periodically,
it's 
* go to the next random number with PNR
* write to PDA and task struct

give or take 10 cycles total if you squeeze it hard, 20 if you don't.
