Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZKFP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZKFP6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZKFP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 10:58:18 -0500
Received: from www.tglx.de ([62.245.132.106]:57987 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbZKFP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:58:17 -0500
Date: Fri, 6 Nov 2009 16:56:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to
 unlocked_ioctl
In-Reply-To: <20091106141542.12404c5c@hyperion.delvare>
Message-ID: <alpine.LFD.2.00.0911061655060.12138@localhost.localdomain>
References: <20091015202722.372890083@linutronix.de> <20091015202758.400949170@linutronix.de> <20091106141542.12404c5c@hyperion.delvare>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009, Jean Delvare wrote:
> I'm not sure why we need to hold the mutex here? My understanding is
> that watchdog_data_mutex protects watchdog_data_list and each
> watchdog's kref. And the above code doesn't touch either.
> 
> What I am more worried about is why ident is declared static. This
> looks like a bug to me. Instead of abusing watchdog_data_mutex to
> workaround this, I'd rather remove the "static". I guess that the
> current code happens to work because neither data->revision nor
> nowayout can change over time, but this looks needlessly fragile.

Right, we can change ident to be non static instead of abusing the
mutex. Stupid me. Will fix.

Thanks,

	tglx
