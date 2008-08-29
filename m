Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbYH2Q4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbYH2Q4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYH2Q4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:56:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752587AbYH2Q4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:56:15 -0400
Date: Fri, 29 Aug 2008 09:55:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix
In-Reply-To: <86802c440808290937y468a4368y9b6ed57ca0cb9896@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808290954580.3300@nehalem.linux-foundation.org>
References: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>  <alpine.LFD.1.10.0808290854000.3300@nehalem.linux-foundation.org> <86802c440808290937y468a4368y9b6ed57ca0cb9896@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> >
> >        void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
> >        {
> >                write_lock(&resource_lock);
> >                while (new->start && new->parent) {

That should obviously be

	while (new->start && !new->parent) {
                            ^^^

oops.

I told you it was untested ;)

		Linus
