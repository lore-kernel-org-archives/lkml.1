Return-Path: <linux-kernel-owner+w=401wt.eu-S1758104AbZKFNWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104AbZKFNWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZKFNWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:22:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZKFNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:22:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to unlocked_ioctl
Date: Fri, 6 Nov 2009 14:22:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, lm-sensors@lm-sensors.org,
       Hans de Goede <hdegoede@redhat.com>
References: <20091015202722.372890083@linutronix.de> <20091015202758.400949170@linutronix.de> <20091106141542.12404c5c@hyperion.delvare>
In-Reply-To: <20091106141542.12404c5c@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061422.49596.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18uERL4AliTM4L9a/1Y31GPL93UPFwoqlY17P1
 ndP7YZIz59nSXWV+9fTOjEcXaTZ/u4fUWne5DDu0JG03QZwoqL
 quL+8rVD7X5ZREaG2XdPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 November 2009, Jean Delvare wrote:
> I'm not sure why we need to hold the mutex here? My understanding is
> that watchdog_data_mutex protects watchdog_data_list and each
> watchdog's kref. And the above code doesn't touch either.
> 
> What I am more worried about is why ident is declared static. This
> looks like a bug to me. Instead of abusing watchdog_data_mutex to
> workaround this, I'd rather remove the "static". I guess that the
> current code happens to work because neither data->revision nor
> nowayout can change over time, but this looks needlessly fragile.
> 
> Hans, any comment?

The data copied into the watchdog_info data structure is completely
static. To make that clearer, I'd suggest moving it outside of
the ioctl function, and initializing it from fschmd_init.
Then it becomes obvious that the mutex is not needed to protect it.

	Arnd <><
