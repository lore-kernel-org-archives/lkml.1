Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbYEBHWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbYEBHWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYEBHWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:22:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbYEBHWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:22:41 -0400
Date: Fri, 2 May 2008 09:22:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
Message-ID: <20080502072226.GB713@elte.hu>
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Commit 85eb69a16aab5a394ce043c2131319eae35e6493 introduced 512 MiB 
> sized kernel and 1.5 GiB sized module space but omitted to change 
> documentation properly. Fix that.

thanks Jiri, applied.

> [Wasn't the hole intentional protection hole?]

> -ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
> -... unused hole ...
> -ffffffff88000000 - fffffffffff00000 (=1919 MB) module mapping space
> +ffffffff80000000 - ffffffffa0000000 (=512 MB)  kernel text mapping, from phys 0
> +ffffffffa0000000 - fffffffffff00000 (=1536 MB) module mapping space

yep, the image was in a 128 MB chunk from which 88 MB was left empty and 
modules started at the next 128 MB boundary. The largest image i ever 
had was around 44MB, so i doubt it's an issue in practice. Mind doing a 
patch that reinstates it, by lowering the 512 image size limit to 508 
MB? [4MB should be more than enough in practice]

	Ingo
