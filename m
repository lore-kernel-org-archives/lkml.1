Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525Ab0A0XIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0A0XIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528Ab0A0XH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:07:58 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44822 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab0A0XHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ug2XMOq1xm5kC9gaLWDvfSYOtfS+WbLMSmMbhVznwdqDaRxLFCWdstjASz+pvS7mLU
         GXdNRnXUJLqfU0JYLM3WOMbbtQ5GrQDRt98ddDIJVdCTIXrrGXYk9ew86aHlSFaYr467
         kRWoXe7yuQP88jH8gC30sds3HbIZIS69dwWso=
Date: Thu, 28 Jan 2010 00:07:51 +0100
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, airlied@linux.ie,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH] PM / i915: Skip kernel VT switch during
 suspend/resume	if KMS is used
Message-ID: <20100128000751.099630ed@strolchi>
In-Reply-To: <20100126145842.GA11295@ucw.cz>
References: <201001240055.59479.rjw@sisk.pl>
	<201001252254.37635.rjw@sisk.pl>
	<20100126141726.GA1437@ucw.cz>
	<201001261947.46015.rjw@sisk.pl>
	<20100126145842.GA11295@ucw.cz>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.19.2; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Jan 2010 15:58:43 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> We need vt switch when display is controlled by userland app directly
> accessing hw. It may or may not be X (svgalib anyone?,
> gtk-on-framebuffer? qtopia?).

anything-on-framebuffer should not be different from plain framebuffer
console, or am I missing something?

> Ideally, userspace should explicitely tell us. KD_KERNEL_GRAPHICS
> console mode?
> 
> Plus the switch is needed for any graphics app using fbcon -- I do not
> think we actually save the framebuffer over suspend. (This one should
> probably be fixed).

Framebuffer should be easy to fix - it works pretty well already
because apparently the fbcon code needs to "shadow buffer" all VT
"windows" anyway - so maybe it's just the issue of doing an additional
"redraw()" somewhere appropriate.

The VGA consoles loses their content, because AFAICT they are in the
graphics card memory, which is not saved and restored.

	seife
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out."
