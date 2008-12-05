Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYLENHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYLENHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYLENG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:06:59 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48663 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYLENG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:06:58 -0500
Date: Fri, 5 Dec 2008 14:06:49 +0100
From: Pavel Machek <pavel@suse.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 062/104] ACPI: EC: count interrupts only if called from
	interrupt handler.
Message-ID: <20081205130649.GB1750@ucw.cz>
References: <20081203193901.715896543@mini.kroah.org> <20081203195300.GK8950@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203195300.GK8950@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-03 11:53:00, Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
> 
> commit 7b4d469228a92a00e412675817cedd60133de38a upstream.
> 
> fix 2.6.28 EC interrupt storm regression
> 

That changelog is pretty useless :-(.

> @@ -219,7 +219,8 @@ static void gpe_transaction(struct acpi_
>  	goto unlock;
>  err:
>  	/* false interrupt, state didn't change */
> -	++ec->curr->irq_count;
> +	if (in_interrupt())
> +		++ec->curr->irq_count;
>  unlock:
>  	spin_unlock_irqrestore(&ec->curr_lock, flags);
>  }

Is preempt_count() reliable with !config_preempt, too?

Using in_interrupt here is quite ugly... definitely worth a comment
and perhaps gpe_transaction should get explicit 'am I in interrupt'
parameter.

At least RT kernels plan on moving interrupt handlers to threads...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
