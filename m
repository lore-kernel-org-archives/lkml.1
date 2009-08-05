Return-Path: <linux-kernel-owner+w=401wt.eu-S934691AbZHEQdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934691AbZHEQdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934685AbZHEQdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:33:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32953 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934682AbZHEQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:33:08 -0400
Date: Wed, 5 Aug 2009 17:33:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805173346.130d80bb@lxorguk.ukuu.org.uk>
In-Reply-To: <4A79AD2A.4060308@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
	<20090805110031.51424dbe@lxorguk.ukuu.org.uk>
	<4A796C94.5040301@suse.de>
	<20090805134823.4409e197@lxorguk.ukuu.org.uk>
	<4A799392.3000108@suse.de>
	<20090805152942.42e785f3@lxorguk.ukuu.org.uk>
	<4A79AD2A.4060308@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see how I would be able to achieve the latter with one liner.
> Can you please elaborate a little bit?

It depends how much of a hurry you are in, but for the mainstream we can
do this

1.	Make soundcore also issue the request_module() as if the char
minor was unclaimed. Mark the old one as obsolete

2.	Wait a year while people adjust their scripts to trigger on the
char event instead (and fix the ordering bits for ALSA if the soundcore
docs are still valid on that)

3.	Apply a patch which makes ALSA use char dev allocation directly
for its OSS devices and dumps out soundcore, remove soundcore and switch
any other code using it.

