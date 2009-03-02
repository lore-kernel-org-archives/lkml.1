Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbZCBIUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbZCBIUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbZCBIU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:20:28 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:41232 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664AbZCBIU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:20:26 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 2 Mar 2009 09:24:36 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: "Arve Hj?nnev?g" <arve@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.0902162156380.24097-100000@netrider.rowland.org> <d6200be20902172046sf00599ckc6710c6132d6b92f@mail.gmail.com> <20090301225647.GE1961@elf.ucw.cz>
In-Reply-To: <20090301225647.GE1961@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903020924.42451.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 01 März 2009 23:56:47 schrieb Pavel Machek:
> > Allowing user space to suspend input devices while they are still open
> > is useful. The user-space code that reads from the input devices does
> > not need to know if the device is suspended or not, and the kernel
> > cannot auto suspend input devices based on inactivity.
>
> Actually, I'd like you to fix your userspace and close input devices
> when it does not need them. Given the way you control the platform it
> should not be that hard. I do not see why we'd want to invent new
> interface for "uhuh, I have opened the keyboard but I am not really
> interested in keys being pressed".

Generally you can't do this. A task has an open fd.

- you cannot assume it can open the device again (fd may be inherited)
- keeping the device open makes sure you are talking to the same device
- you may want to avoid repeating expensive initialisations
- some input devices also do output

	Regards
		Oliver

