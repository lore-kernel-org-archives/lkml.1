Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXFZIH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXFZIH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXFZIHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:07:46 -0400
Received: from www19.your-server.de ([213.133.104.19]:46674 "EHLO
	www19.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbXFZIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:07:44 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] PM: Prevent frozen user mode helpers from failing the freezing of tasks (rev. 2)
Date: Tue, 26 Jun 2007 10:07:38 +0200
User-Agent: KMail/1.9.7
References: <200706252352.24137.rjw@sisk.pl>
In-Reply-To: <200706252352.24137.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261007.38945.u.luckas@road.de>
X-Authenticated-Sender: webmaster@road.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday, 25. June 2007, Rafael J. Wysocki wrote:
> [I hope the ACKs still apply.]
>
Mine does 

> +static void helper_lock(void)
> +{
> +       atomic_inc(&running_helpers);
> +       smp_mb__after_atomic_inc();
> +}
> +
> +static void helper_unlock(void)
> +{
> +       if (atomic_dec_and_test(&running_helpers))
> +               wake_up(&running_helpers_waitq);
> +}
> +
> +static void register_pm_notifier_callback(void)
> +{
> +       pm_notifier(usermodehelper_pm_callback, 0);
> +}
> +#else /* CONFIG_PM */

> +static inline void helper_lock(void) {}
> +static inline void helper_unlock(void) {}
> +static inline void register_pm_notifier_callback(void) {}
>

Sorry for not realising this before, but I think, we should also inline the 
actual implementations of helper_lock, helper_unlock and 
register_pm_notifier_callback

Regards
Uli


-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
